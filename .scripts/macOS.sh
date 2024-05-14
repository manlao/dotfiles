#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

export XCODE_APP_ID="497799835"
export HOMEBREW_BUNDLE_FILE="$DOTFILES_HOME/macOS/homebrew/Brewfile"
export HOMEBREW_BUNDLE_MAS_SKIP="$XCODE_APP_ID"
export HOMEBREW_CASK_OPTS="--no-quarantine"
SUDOERS="$DOTFILES_HOME/macOS/sudoers"

install() {
  local DEVICE_NAME HOST_NAME

  set_variable DEVICE_NAME "Computer Name" "$(sudo scutil --get ComputerName)"
  set_variable HOST_NAME "Host Name" "$(sudo scutil --get LocalHostName)"

  install_homebrew
  install_homebrew_taps
  install_homebrew_packages

  run_directory "$DOTFILES_HOME/.scripts/common" install
  run_directory "$DOTFILES_HOME/.scripts/macOS" install
}

install_homebrew() {
  if brew -v 1>/dev/null 2>&1; then
    return
  fi

  message --info "Install homebrew"

  # https://brew.sh
  CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_homebrew_taps() {
  message --info "Install homebrew taps"

  brew tap homebrew/homebrew-core
  brew tap homebrew/homebrew-cask
}

install_homebrew_packages() {
  message --info "Install homebrew packages and mas apps"

  brew bundle install --verbose

  if ! grep -E "id:[[:space:]]*$XCODE_APP_ID""[,[:space:]]*" "$HOMEBREW_BUNDLE_FILE" 1>/dev/null 2>&1; then
    return
  fi

  if mas list | grep -E "^$XCODE_APP_ID""[[:space:]]+" 1>/dev/null 2>&1; then
    return
  fi

  mas install "$XCODE_APP_ID"
  sudo xcodebuild -license accept
}

setup() {
  setup_system
  setup_touch_id
  setup_terminal
  setup_dock

  run_directory "$DOTFILES_HOME/.scripts/common" setup
  run_directory "$DOTFILES_HOME/.scripts/macOS" setup
}

setup_system() {
  message --info "Set up system"

  sudo ln -sf "$SUDOERS" "/private/etc/sudoers.d/sudoers"
  sudo chown 0 "$SUDOERS" 1>/dev/null 2>&1

  if [ -n "$DEVICE_NAME" ]; then
    sudo scutil --set ComputerName "$DEVICE_NAME"
  fi

  if [ -n "$HOST_NAME" ]; then
    sudo scutil --set LocalHostName "$HOST_NAME"
  fi

  # Hardware UUID
  # local UUID
  # UUID=$(system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }')

  # Automatic Restart on System Freeze
  # sudo systemsetup -setrestartfreeze on

  # Disable the “Are you sure you want to open this application?” dialog
  # defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -boolean true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -boolean true
}

setup_touch_id() {
  configure_touch_id
}

setup_terminal() {
  message --info "Set up Terminal"

  if ! defaults read com.apple.Terminal | grep "macOS =" 1>/dev/null 2>&1; then
    # Import profile: macOS
    open -n -g -a "/System/Applications/Utilities/Terminal.app" "$DOTFILES_HOME/macOS/terminal/macOS.terminal"

    # Terminal -> Preferences -> Profiles -> Default
    defaults write com.apple.Terminal "Default Window Settings" -string "macOS"

    # Terminal -> Preferences -> General -> On startup, open: New window with profile
    defaults write com.apple.Terminal "Startup Window Settings" -string "macOS"
  fi
}

setup_dock() {
  configure_dock
}

update() {
  update_system
  update_touch_id
  update_homebrew
  update_homebrew_packages
  update_dock

  run_directory "$DOTFILES_HOME/.scripts/common" update
  run_directory "$DOTFILES_HOME/.scripts/macOS" update
}

update_system() {
  message --info "Update system"

  sudo chown 0 "$SUDOERS" 1>/dev/null 2>&1

  if sudo softwareupdate -l | grep "Action: restart" 1>/dev/null 2>&1; then
    local REBOOT
    read -r -p "Restart is required to complete installation of some softwares. Install and restart now?（Y/N）" REBOOT

    if [ "$REBOOT" = "Y" ] || [ "$REBOOT" = "y" ]; then
      sudo softwareupdate -i -a -R
    else
      sudo softwareupdate -d -a
    fi
  else
    sudo softwareupdate -i -a
  fi
}

update_touch_id() {
  configure_touch_id
}

update_homebrew() {
  message --info "Update homebrew"
  brew update
}

update_homebrew_packages() {
  message --info "Update homebrew packages and mas apps"

  brew upgrade --greedy

  if ! brew bundle check 1>/dev/null 2>&1; then
    brew bundle install --verbose
  fi

  # open updated cask
  relanuch_app Rectangle.app
  relanuch_app MonitorControl.app

  if mas version 1>/dev/null 2>&1; then
    mas upgrade
  fi

  # open updated app
  relanuch_app Amphetamine.app
}

update_dock() {
  configure_dock
}

relanuch_app() {
  if ! ps aux | grep -v grep | grep "$1" 1>/dev/null 2>&1; then
    open -g -a "$1"
  fi
}

sync() {
  sync_homebrew_packages

  run_directory "$DOTFILES_HOME/.scripts/common" sync
  run_directory "$DOTFILES_HOME/.scripts/macOS" sync
}

sync_homebrew_packages() {
  message --info "Sync homebrew packages"

  brew bundle cleanup --verbose
  brew autoremove
}

configure_touch_id() {
  message --info "Config Touch ID"

  # https://support.apple.com/en-hk/109030
  if [ ! -f "/etc/pam.d/sudo_local" ]; then
    sudo cp "/etc/pam.d/sudo_local.template" "/etc/pam.d/sudo_local"
    sudo sed -i "" "s/#auth/auth/" "/etc/pam.d/sudo_local"
  fi

  # https://gitlab.com/gnachman/iterm2/-/issues/7618
  local LINE_NO
  LINE_NO=$(sed -n "/^[^#]/=" "/etc/pam.d/sudo_local" | head -1)

  if ! grep "pam_reattach.so" "/etc/pam.d/sudo_local" 1>/dev/null 2>&1; then
    sudo sed -i "" "$LINE_NO i \\
auth       optional       $(brew --prefix)/lib/pam/pam_reattach.so
" "/etc/pam.d/sudo_local"
  fi

  if ! grep "pam_tid.so" "/etc/pam.d/sudo_local" 1>/dev/null 2>&1; then
    sudo sed -i "" "$((LINE_NO + 1)) i \\
auth       sufficient     pam_tid.so
" "/etc/pam.d/sudo_local"
  fi
}

configure_dock() {
  message --info "Config Dock"

  local PLIST="$HOME/Library/Preferences/com.apple.dock.plist"

  /usr/libexec/PlistBuddy -c "Delete :persistent-apps" "${PLIST}"
  /usr/libexec/PlistBuddy -c "Add :persistent-apps array" "${PLIST}"

  local I APPS=(
    "169,启动台,/System/Applications/Launchpad.app"
    "41,iTerm,/Applications/iTerm.app"
    "41,Visual Studio Code,/Applications/Visual Studio Code.app"
    "41,Google Chrome,/Applications/Google Chrome.app"
    "41,Slack,/Applications/Slack.app"
    "41,微信,/Applications/WeChat.app"
    "41,企业微信,/Applications/企业微信.app"
    "41,邮件,/System/Applications/Mail.app"
    "41,App Store,/System/Applications/App Store.app"
    "41,系统偏好设置,/System/Applications/System Preferences.app"
    "41,系统设置,/System/Applications/System Settings.app"
  )

  local SEGMENTS

  for I in "${!APPS[@]}"; do
    IFS="," read -r -a SEGMENTS <<<"${APPS[I]}"

    if [ -d "${SEGMENTS[2]}" ]; then
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I dict" "${PLIST}"
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I:GUID string $(uuidgen)" "${PLIST}"
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I:tile-type string file-tile" "${PLIST}"
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I:tile-data dict" "${PLIST}"
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I:tile-data:file-type integer ${SEGMENTS[0]}" "${PLIST}"
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I:tile-data:file-label string '${SEGMENTS[1]}'" "${PLIST}"
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I:tile-data:file-data dict" "${PLIST}"
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I:tile-data:file-data:_CFURLStringType integer 15" "${PLIST}"
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$I:tile-data:file-data:_CFURLString string 'file://${SEGMENTS[2]}/'" "${PLIST}"
    fi
  done

  defaults write com.apple.dock ResetLaunchPad -bool true
  killall Dock
}

main "$@"
