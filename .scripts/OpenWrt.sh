#!/usr/bin/env bash

# shellcheck disable=SC1090
source "$DOTFILES_HOME/trait.rc"

export OPKGFILE="$DOTFILES_HOME/OpenWrt/opkg/Opkgfile"

install() {
  install_opkg_custom_feeds
  install_packages

  run_directory "$DOTFILES_HOME/.scripts/common" install
  run_directory "$DOTFILES_HOME/.scripts/OpenWrt" install
}

install_opkg_custom_feeds() {
  # http://openwrt-dist.sourceforge.net/
  if ! grep -q "openwrt_dist" "/etc/opkg/customfeeds.conf"; then
    message --info "Install opkg custom feeds"

    local ARCHITECTURE
    ARCHITECTURE=$("$DOTFILES_HOME/install" get_architecture)

    wget "http://openwrt-dist.sourceforge.net/packages/openwrt-dist.pub" -O "/tmp/openwrt-dist.pub"
    opkg-key add "/tmp/openwrt-dist.pub"
    echo "src/gz openwrt_dist http://openwrt-dist.sourceforge.net/packages/base/$ARCHITECTURE" >> "/etc/opkg/customfeeds.conf"
    echo "src/gz openwrt_dist_luci http://openwrt-dist.sourceforge.net/packages/luci" >> "/etc/opkg/customfeeds.conf"
  fi
}

install_packages() {
  message --info "Install packages"

  opkg update
  opkg remove dnsmasq
  opkg dnsmasq-full
  opkg install "$(read_opkgfile)"
}

setup() {
  setup_opkg_mirror
  setup_timezone
  setup_fstab
  setup_tfo
  setup_dnsmasq
  setup_dns_forwarder
  setup_firewall_rules

  run_directory "$DOTFILES_HOME/.scripts/common" setup
  run_directory "$DOTFILES_HOME/.scripts/OpenWrt" setup
}

setup_opkg_mirror() {
  message --info "Set up opkg mirror"

  # back up distfeeds.conf
  if [ ! -f /etc/opkg/distfeeds.conf.bak ]; then
    cp -f /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.bak
  fi

  # replace domain
  sed -i -r "s/^(.*)(http:\/\/downloads\.openwrt\.org)(.*)$/\1http:\/\/mirrors\.cqu\.edu\.cn\/openwrt\3/" /etc/opkg/distfeeds.conf
}

setup_timezone() {
  message --info "Set up timezone"

  uci set system.@system[0].timezone="CST-8"
  uci set system.@system[0].zonename="Asia/Shanghai"
  uci commit
}

setup_fstab() {
  message --info "Set up file system table"

  uci set fstab.@global[0].anon_swap="1"
  uci set fstab.@global[0].anon_mount="1"
  uci set fstab.@global[0].check_fs="1"
  uci commit
}

setup_tfo() {
  message --info "Set up TCP Fast Open"

  echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
  sysctl -p
}

setup_dnsmasq() {
  message --info "Set up dnsmasq"

  mkdir -p "/etc/dnsmasq.d"
  echo "conf-dir=/etc/dnsmasq.d" >> "/etc/dnsmasq.conf"

  # download dnsmasq gfwlist ipset
  local URL="https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist_ipset.conf"
  local CONF="/etc/dnsmasq.d/dnsmasq_gfwlist_ipset.conf"
  curl -fsSL "$URL" -o "$CONF"

  # add cron task at 2:00 am
  echo "2 0 * * * curl -fsSL $URL -o $CONF" > "/etc/crontabs/root"

  uci del dhcp.@dnsmasq[0].boguspriv
  uci del dhcp.@dnsmasq[0].filterwin2k
  uci del dhcp.@dnsmasq[0].nonegcache
  uci del dhcp.@dnsmasq[0].nonwildcard
  uci add_list dhcp.@dnsmasq[0].server="114.114.114.114"
  uci commit
}

setup_dns_forwarder() {
  message --info "Set up DNS-Forwarder"

  uci set dns-forwarder.@dns-forwarder[0].enable="1"
  uci set dns-forwarder.@dns-forwarder[0].listen_port="5353"
  # WAN DNS
  uci set network.wan.peerdns="0"
  uci add_list network.wan.dns="127.0.0.1"
  uci commit
}

setup_firewall_rules() {
  message --info "Set up firewall rules"

  cat <<EOF > "/etc/firewall.user"
ipset -N gfwlist iphash
iptables -t nat -A PREROUTING -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1100
iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1100
ip6tables -t nat -A PREROUTING -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1100
ip6tables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1100

ipset add gfwlist 8.8.8.8
EOF
}

update() {
  update_opkg
  update_packages

  run_directory "$DOTFILES_HOME/.scripts/common" update
  run_directory "$DOTFILES_HOME/.scripts/OpenWrt" update
}

update_opkg() {
  message --info "Update opkg"
  opkg update
}

update_packages() {
  message --info "Update packages"
  opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade
}

sync() {
  run_directory "$DOTFILES_HOME/.scripts/common" sync
  run_directory "$DOTFILES_HOME/.scripts/OpenWrt" sync
}

read_opkgfile() {
  local I LINES PKGS=()
  LINES=$(read_lines "$OPKGFILE")

  # Remove empty and comment lines
  for I in "${!LINES[@]}"; do
    if [ -n "${LINES[I]}" ] && ! [[ "${LINES[I]}" =~ ^[[:space:]]*\# ]]; then
      PKGS+=("${LINES[I]}")
    fi
  done

  echo "${PKGS[@]}"
}

read_lines() {
  local LINES=()

  if [ -f "$1" ]; then
    if ! mapfile -t LINES < "$1" 1>/dev/null 2>&1; then
      local LINE
      while IFS="" read -r LINE; do LINES+=("$LINE"); done < "$1"
    fi
  fi

  echo "${LINES[@]}"
}

main "$@"
