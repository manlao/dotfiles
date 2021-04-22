#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

ITERM2_WEBSITE_FOLDER="$HOME/.iterm2-website"
ITERM2_COLOR_SCHEMES_FOLDER="$HOME/.iTerm2-Color-Schemes"
DEFAULT_SHELL="${DEFAULT_SHELL:-zsh}"

install() {
  install_iterm2
  # install_iterm2_website
  # install_iterm2_color_schemes
}

install_iterm2() {
  if ! brew list --cask iterm2 1>/dev/null 2>&1; then
    message --info "Install homebrew cask: iterm2"
    brew install --cask iterm2
  fi
}

install_iterm2_website() {
  if [ ! -d "$ITERM2_WEBSITE_FOLDER" ]; then
    message --info "Clone gnachman/iterm2-website"

    rm -rf "$ITERM2_WEBSITE_FOLDER"
    git clone "https://github.com/gnachman/iterm2-website.git" "$ITERM2_WEBSITE_FOLDER"
  fi
}

install_iterm2_color_schemes() {
  if [ ! -d "$ITERM2_COLOR_SCHEMES_FOLDER" ]; then
    message --info "Clone mbadolato/iTerm2-Color-Schemes"

    rm -rf "$ITERM2_COLOR_SCHEMES_FOLDER"
    git clone "https://github.com/mbadolato/iTerm2-Color-Schemes.git" "$ITERM2_COLOR_SCHEMES_FOLDER"
  fi
}

setup() {
  setup_iterm2
  # setup_iterm2_website
  # setup_iterm2_color_schemes
}

setup_iterm2() {
  message --info "Set up iTerm2"

  # Dynamic Profiles
  local FOLDER="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  mkdir -p "$FOLDER"
  cp -f "$DOTFILES_HOME/macOS/iterm2/profiles.json" "$FOLDER/profiles.json"

  # iTerm2 -> Show Tip of the Day -> More Options -> Disable Tips
  defaults write com.googlecode.iterm2 NoSyncTipsDisabled -boolean true

  # iTerm2 -> Preferences -> General -> Closing -> Quit when all windows are closed
  defaults write com.googlecode.iterm2 QuitWhenAllWindowsClosed -boolean true
  # iTerm2 -> Preferences -> General -> Closing -> Confirm closing multiple sessions
  defaults write com.googlecode.iterm2 OnlyWhenMoreTabs -boolean false
  # iTerm2 -> Preferences -> General -> Closing -> Confirm "Quit iTerm2 (⌘Q)" if windows open
  defaults write com.googlecode.iterm2 PromptOnQuit -boolean false

  # iTerm2 -> Preferences -> General -> Magic -> Enable Python API
  defaults write com.googlecode.iterm2 EnableAPIServer -boolean true

  # iTerm2 -> Preferences -> General -> Services -> Check for updates automaticlly
  defaults write com.googlecode.iterm2 SUEnableAutomaticChecks -boolean true

  # iTerm2 -> Preferences -> General -> Selection -> Applications in terminal may access clipboard
  defaults write com.googlecode.iterm2 AllowClipboardAccess -boolean true
  # iTerm2 -> Preferences -> General -> Selection -> Double-click performs smart selection
  defaults write com.googlecode.iterm2 DoubleClickPerformsSmartSelection -boolean true

  # iTerm2 -> Preferences -> General -> Window -> Adjust window when changing font size
  defaults write com.googlecode.iterm2 AdjustWindowForFontSizeChange -boolean false

  # iTerm2 -> Preferences -> Appearance -> General -> Theme: 4 - Regular, 5 - Mininal, 6 - Compact
  defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -integer 5
  # iTerm2 -> Preferences -> Appearance -> General -> Status bar location: 0 - Top, 1 - Bottom
  defaults write com.googlecode.iterm2 StatusBarPosition -integer 1

  # iTerm2 -> Preferences -> Appearance -> Windows -> Show border around windows: 0 - Top, 1 - Bottom
  defaults write com.googlecode.iterm2 UseBorder -boolean true

  # iTerm2 -> Preferences -> Appearance -> Tabs -> Preserve window size when tab bar shows or hides
  defaults write com.googlecode.iterm2 PreserveWindowSizeWhenTabBarVisibilityChanges -boolean true
  # iTerm2 -> Preferences -> Appearance -> Tabs -> Stretch tabs to fill bar
  defaults write com.googlecode.iterm2 StretchTabsToFillBar -boolean true

  # iTerm2 -> Preferences -> Appearance -> Panes -> Separate status bars per pane
  defaults write com.googlecode.iterm2 SeparateStatusBarsPerPane -boolean true

  # iTerm2 -> Preferences -> Appearance -> Dimming -> Dim background winodws
  defaults write com.googlecode.iterm2 DimBackgroundWindows -boolean true
  # iTerm2 -> Preferences -> Appearance -> Dimming -> Dimming affects only text, not background.
  defaults write com.googlecode.iterm2 DimOnlyText -boolean true

  # iTerm2 -> Preferences -> Advanced -> Windows -> Terminal windows resize smoothly
  defaults write com.googlecode.iterm2 DisableWindowSizeSnap -boolean true

  # iTerm2 -> Preferences -> Advanced -> Mouse -> Scroll wheel sends arraw keys when in alternate screen mode
  defaults write com.googlecode.iterm2 AlternateMouseScroll -boolean true

  # iTerm2 -> Preferences -> Profiles -> Set default profile
  defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "macOS"

  # iTerm2 -> Make iTerm2 Default Term
  duti -s com.googlecode.iterm2 .command all
  duti -s com.googlecode.iterm2 .tool all
  duti -s com.googlecode.iterm2 .zsh all
  duti -s com.googlecode.iterm2 .csh all
  duti -s com.googlecode.iterm2 .pl all
}

setup_iterm2_website() {
  message --info "Set up iTerm2 shell integration and utilities"

  ln -sf "$ITERM2_WEBSITE_FOLDER/source/shell_integration/$DEFAULT_SHELL" "$HOME/.iterm2_shell_integration.$DEFAULT_SHELL"
  ln -sf "$ITERM2_WEBSITE_FOLDER/source/utilities" "$HOME/.iterm2"
}

setup_iterm2_color_schemes() {
  message --info "Set up iTerm2 color scheme"
  open -g -a "/Applications/iTerm.app" "$ITERM2_COLOR_SCHEMES_FOLDER/schemes/3024 Night.itermcolors"
}

update() {
  return
  # update_iterm2_website
  # update_iterm2_color_schemes
}

update_iterm2_website() {
  message --info "Update gnachman/iterm2-website"
  git -C "$ITERM2_WEBSITE_FOLDER" pull
}

update_iterm2_color_schemes() {
  message --info "Update mbadolato/iTerm2-Color-Schemes"
  git -C "$ITERM2_COLOR_SCHEMES_FOLDER" pull
}

main "$@"
