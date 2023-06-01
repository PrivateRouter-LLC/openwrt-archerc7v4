#!/bin/bash

# autoprovision stage 2: this script will be executed upon boot if the extroot was successfully mounted (i.e. rc.local is run from the extroot overlay)

. /etc/auto-provision/autoprovision-functions.sh

# Command to check if a command ran successfully
check_run() {
    if eval "$@"; then
        return 0  # Command ran successfully, return true
    else
        return 1  # Command failed to run, return false
    fi
}

# Log to the system log and echo if needed
log_say()
{
    SCRIPT_NAME=$(basename "$0")
    echo "${SCRIPT_NAME}: ${1}"
    logger "${SCRIPT_NAME}: ${1}"
}

# Command to wait for Internet connection
wait_for_internet() {
    while ! ping -q -c3 1.1.1.1 >/dev/null 2>&1; do
        log_say "Waiting for Internet connection..."
        sleep 1
    done
    log_say "Internet connection established"
}

# Command to wait for opkg to finish
wait_for_opkg() {
  while pgrep -x opkg >/dev/null; do
    log_say "Waiting for opkg to finish..."
    sleep 1
  done
  log_say "opkg is released, our turn!"
}

installPackages()
{
    signalAutoprovisionWaitingForUser

    until (opkg update)
    do
        log_say "opkg update failed. No internet connection? Retrying in 15 seconds..."
        sleep 15
    done

    signalAutoprovisionWorking

    log_say "Autoprovisioning stage2 is about to install packages"

    # CUSTOMIZE
    # install some more packages that don't need any extra steps
    log_say "updating all packages!"

    log_say "                                                                      "
    log_say " ███████████             ███                         █████            "
    log_say "░░███░░░░░███           ░░░                         ░░███             "
    log_say " ░███    ░███ ████████  ████  █████ █████  ██████   ███████    ██████ "
    log_say " ░██████████ ░░███░░███░░███ ░░███ ░░███  ░░░░░███ ░░░███░    ███░░███"
    log_say " ░███░░░░░░   ░███ ░░░  ░███  ░███  ░███   ███████   ░███    ░███████ "
    log_say " ░███         ░███      ░███  ░░███ ███   ███░░███   ░███ ███░███░░░  "
    log_say " █████        █████     █████  ░░█████   ░░████████  ░░█████ ░░██████ "
    log_say "░░░░░        ░░░░░     ░░░░░    ░░░░░     ░░░░░░░░    ░░░░░   ░░░░░░  "
    log_say "                                                                      "
    log_say "                                                                      "
    log_say " ███████████                        █████                             "
    log_say "░░███░░░░░███                      ░░███                              "
    log_say " ░███    ░███   ██████  █████ ████ ███████    ██████  ████████        "
    log_say " ░██████████   ███░░███░░███ ░███ ░░░███░    ███░░███░░███░░███       "
    log_say " ░███░░░░░███ ░███ ░███ ░███ ░███   ░███    ░███████  ░███ ░░░        "
    log_say " ░███    ░███ ░███ ░███ ░███ ░███   ░███ ███░███░░░   ░███            "
    log_say " █████   █████░░██████  ░░████████  ░░█████ ░░██████  █████           "
    log_say "░░░░░   ░░░░░  ░░░░░░    ░░░░░░░░    ░░░░░   ░░░░░░  ░░░░░            "

    # Keep trying to run opkg update until it succeeds
    while ! check_run "opkg update"; do
        log_say "\"opkg update\" failed. Retrying in 15 seconds..."
        sleep 15
    done
    
    # List of our packages to install
    local PACKAGE_LIST="kmod-ipt-conntrack fwtool kmod-udptunnel4 usbutils kmod-udptunnel6 luci-app-samba4 base-files wget-ssl luci-app-opkg kmod-crypto-lib-poly1305 speedtest-netperf git kmod-lib-crc-ccitt luci-app-nlbwmon luci-app-statistics iptables getrandom libc libip6tc2 ca-bundle kmod-usb-core luci-mod-dashboard iw minidlna kmod-pppoe kmod-ip6tables kmod-usb-net-cdc-subset luci-app-commands kmod-nf-conntrack kmod-pppox kmod-phy-ath79-usb samba4-server kmod-usb-net-ipheth luci-lib-jsonc kmod-nf-reject6 kmod-ipt-core libimobiledevice luci-compat luci-lib-base ttyd kmod-ipt-nat luci-lib-ipkg kmod-fs-ext4 luci-app-openvpn kmod-crypto-lib-chacha20 ip6tables kmod-fs-exfat kmod-usb-ehci kmod-nf-ipt kmod-crypto-lib-curve25519 luci-mod-system kmod-usb-net kmod-nf-flow fstools iwinfo bash kmod-slhc luci luci-base liblucihttp0 kmod-nf-conntrack6 vsftpd luci-lib-nixio libopenssl1.1 logd libpthread libuci20130104 libxtables12 luci-mod-admin-full hostapd-common block-mount firewall kmod-usb-storage libiwinfo-data libjson-c5 busybox libustream-wolfssl20201210 libjson-script20210516 kmod-crypto-hash zlib unzip usbmuxd libuclient20201210 rpcd-mod-luci kmod-crypto-kpp luci-app-adblock kmod-nls-base kmod-usb-net-rndis kmod-ath9k luci-app-vnstat jshn kmod-crypto-lib-chacha20poly1305 fail2ban dropbear cgi-io nano luci-app-wireguard wget luci-lib-ip jsonfilter kmod-usb-net-cdc-eem fdisk openvpn-openssl openssh-sftp-client libiwinfo-lua kmod-cfg80211 libubus-lua liblucihttp-lua kmod-nf-ipt6 lua luci-app-minidlna jq kmod-usb-ledtrig-usbport kernel libnl-tiny1 kmod-usb-net-cdc-ether kmod-nf-nat libgcc1 liblua5.1.5 luci-app-firewall kmod-ppp libiwinfo20210430 kmod-usb2 luci-mod-status luci-mod-network kmod-ath9k-common curl libubus20210630 kmod-wireguard kmod-mac80211 kmod-ath libip4tc2 e2fsprogs libubox20210516 kmod-nf-reject kmod-gpio-button-hotplug git-http kmod-ipt-offload"

    count=$(echo "$PACKAGE_LIST" | wc -w)
    log_say "Packages to install: ${count}"

    # Convert the object list to an array
    IFS=' ' read -r -a objects <<< "$PACKAGE_LIST"

    # Loop until the object_list array is empty
    while [[ ${#objects[@]} -gt 0 ]]; do
        # Get a slice of 10 objects or the remaining objects if less than 10
        slice=("${objects[@]:0:10}")

        # Remove the echoed objects from the list
        objects=("${objects[@]:10}")

        # Join the slice into a single line with spaces
        line=$(printf "%s " "${slice[@]}")

        # Remove leading/trailing whitespaces
        line=$(echo "$line" | xargs)

        # opkg install the 10 packages
        eval "opkg install $line"
    done

   ## We have to remove dnsmasq (which is required to be installed on build) and install dnsmasq-full
   opkg remove dnsmasq
   # Get rid of the old dhcp config
   [ -f /etc/config/dhcp ] && rm /etc/config/dhcp
   # Install the dnsmasq-full package since we want that
   opkg install dnsmasq-full
   # Move the default dhcp config to the right place
   [ -f /etc/config/dhcp ] && mv /etc/config/dhcp /etc/config/dhcp.orig
   # Put our pre-configured config in its place
   [[ -f /etc/config/dhcp.pr && ! -f /etc/config/dhcp ]] && cp /etc/config/dhcp.pr /etc/config/dhcp

}

autoprovisionStage2()
{
    log_say "Autoprovisioning stage2 speaking"

    signalAutoprovisionWorking

    # CUSTOMIZE: with an empty argument it will set a random password and only ssh key based login will work.
    # please note that stage2 requires internet connection to install packages and you most probably want to log_say in
    # on the GUI to set up a WAN connection. but on the other hand you don't want to end up using a publically
    # available default password anywhere, therefore the random here...
    setRootPassword "torguard"

    installPackages

    chmod +x ${overlay_root}/etc/rc.local
    cat >${overlay_root}/etc/rc.local <<EOF
chmod a+x /etc/stage3.sh
{ bash /etc/stage3.sh; } && exit 0 || { log "** PRIVATEROUTER ERROR **: stage3.sh failed - rebooting in 30 seconds"; sleep 30; reboot; }
EOF

}

# Fix our DNS and update packages and do not check https certs
fixPackagesDNS()
{
    log_say "Fixing DNS (if needed) and installing required packages for opkg"

    # Domain to check
    domain="privaterouter.com"

    # DNS server to set if domain resolution fails
    dns_server="1.1.1.1"

    # Perform the DNS resolution check
    if ! nslookup "$domain" >/dev/null 2>&1; then
        log_say "Domain resolution failed. Setting DNS server to $dns_server."

        # Update resolv.conf with the new DNS server
        echo "nameserver $dns_server" > /etc/resolv.conf
    else
        log_say "Domain resolution successful."
    fi

    log_say "Updating system time using ntp; otherwise the openwrt.org certificates are rejected as not yet valid."
    ntpd -d -q -n -p 0.openwrt.pool.ntp.org

    log_say "Installing opkg packages"
    opkg update
    opkg install wget-ssl unzip ca-bundle ca-certificates
    opkg install git git-http jq curl bash nano
}

# Wait for Internet connection
wait_for_internet

# Wait for opkg to finish
wait_for_opkg

# Fix our DNS Server and install some required packages
fixPackagesDNS

autoprovisionStage2

reboot
