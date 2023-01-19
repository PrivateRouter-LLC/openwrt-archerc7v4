#!/bin/sh

# autoprovision stage 2: this script will be executed upon boot if the extroot was successfully mounted (i.e. rc.local is run from the extroot overlay)

. /etc/auto-provision/autoprovision-functions.sh

installPackages()
{
    signalAutoprovisionWaitingForUser

    until (opkg update)
     do
        log "opkg update failed. No internet connection? Retrying in 15 seconds..."
        sleep 15
    done

    signalAutoprovisionWorking

    log "Autoprovisioning stage2 is about to install packages"
    sed -i 's,https,http,g' /etc/opkg/distfeeds.conf;

     opkg update
   #Go Go Packages
   opkg install opkg install openvpn-openssl luci-app-openvpn base-files usbutils busybox ca-bundle cgi-io dnsmasq dropbear openssh-sftp-client firewall fstools fwtool getrandom hostapd-common ip6tables iptables iw iwinfo jshn jsonfilter

   opkg install kernel kmod-ath kmod-ath9k kmod-ath9k-common kmod-cfg80211 kmod-crypto-hash kmod-crypto-kpp kmod-crypto-lib-blake2s kmod-crypto-lib-chacha20 kmod-crypto-lib-chacha20poly1305 kmod-crypto-lib-curve25519

   opkg install kmod-crypto-lib-poly1305 kmod-gpio-button-hotplug kmod-ip6tables kmod-ipt-conntrack kmod-ipt-core kmod-ipt-nat kmod-ipt-offload kmod-lib-crc-ccitt kmod-mac80211 kmod-nf-conntrack kmod-nf-conntrack6 kmod-nf-flow kmod-nf-ipt

   opkg install kmod-nf-ipt6 kmod-nf-nat kmod-nf-reject kmod-nf-reject6 kmod-nls-base kmod-phy-ath79-usb kmod-ppp kmod-pppoe kmod-pppox

   opkg install kmod-slhc kmod-udptunnel4 kmod-udptunnel6 kmod-usb-core kmod-usb-ehci kmod-usb-ledtrig-usbport kmod-usb2 kmod-wireguard libblobmsg-json20210516 libc libgcc1 libip4tc2 libip6tc2 libiwinfo-data libiwinfo-lua libiwinfo20210430 libjson-c5

   opkg install libjson-script20210516 liblua5.1.5 liblucihttp-lua liblucihttp0 libnl-tiny1 libopenssl1.1 libpthread libubox20210516

   opkg install libubus-lua libubus20210630 libuci20130104 libuclient20201210 libustream-wolfssl20201210 libwolfssl4.8.1.66253b90 libxtables12 logd lua luci luci-app-firewall luci-app-opkg luci-app-wireguard luci-base luci-compat

   opkg install luci-lib-base luci-lib-ip luci-lib-ipkg luci-lib-jsonc luci-lib-nixio luci-mod-admin-full luci-mod-network luci-mod-status luci-mod-system

   opkg install git git-http jq curl bash wget kmod-usb-net-rndis luci-mod-dashboard luci-app-commands luci-app-vnstat
   opkg install rpcd-mod-luci luci-app-statistics luci-app-samba4 samba4-server luci-mod-admin-full luci-mod-network luci-mod-status luci-mod-system kmod-usb-net-cdc-eem
   opkg install kmod-usb-net-cdc-ether kmod-usb-net-cdc-subset kmod-nls-base kmod-usb-core kmod-usb-net kmod-usb-net-cdc-ether kmod-usb2 kmod-usb-net-ipheth
   opkg install usbmuxd libimobiledevice usbutils luci-app-nlbwmon luci-app-adblock nano ttyd fail2ban speedtest-netperf opkg install vsftpd samba36-server luci-app-samba

   opkg install zlib kmod-usb-storage block-mount luci-app-minidlna minidlna kmod-fs-ext4 kmod-fs-exfat e2fsprogs fdisk

  ## V2RAYA INSTALLER ##
   echo "Installing V2rayA..."
  ## download

  opkg update; opkg install unzip wget-ssl

    ## Remove DNSMasq

  opkg remove dnsmasq

  opkg install dnsmasq-full

  opkg install v2raya

  opkg install /etc/luci-app-v2raya_6_all.ipk
  sed -i 's,http,https,g' /etc/opkg/distfeeds.conf;

}

autoprovisionStage2()
{
    log "Autoprovisioning stage2 speaking"

    # TODO this is a rather sloppy way to test whether stage2 has been done already, but this is a shell script...
    if [ $(uci get system.@system[0].log_type) == "file" ]; then
        log "Seems like autoprovisioning stage2 has been done already. Running stage3."
        #/root/autoprovision-stage3.py
    else
        signalAutoprovisionWorking

	echo Updating system time using ntp; otherwise the openwrt.org certificates are rejected as not yet valid.
        ntpd -d -q -n -p 0.openwrt.pool.ntp.org

        # CUSTOMIZE: with an empty argument it will set a random password and only ssh key based login will work.
        # please note that stage2 requires internet connection to install packages and you most probably want to log in
        # on the GUI to set up a WAN connection. but on the other hand you don't want to end up using a publically
        # available default password anywhere, therefore the random here...
        #setRootPassword ""

        installPackages

        cat >${overlay_root}/etc/rc.local <<EOF
chmod a+x /etc/stage3.sh
bash /etc/stage3.sh || exit 1
EOF

        mkdir -p /var/log/archive

        # logrotate is complaining without this directory
        mkdir -p /var/lib

        uci set system.@system[0].log_type=file
        uci set system.@system[0].log_file=/var/log/syslog
        uci set system.@system[0].log_size=0

        uci commit
        sync
        reboot
    fi
}

autoprovisionStage2
