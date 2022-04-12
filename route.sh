#!/bin/bash

# Settings the defaults ideal for OSCP/HTB etc.
listen="eth0"
forward="tun0"
ovpnconfig="config.ovpn"

# Check to ensure the script is run as root/sudo
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root. Get in the bin." 1>&2
    exit 1
fi

while getopts l:f:c flag
do
    case "${flag}" in
        l) listen=${OPTARG};;
	f) forward=${OPTARG};;
	c) ovpnconfig=${OPTARG};;
    esac
done

function system_setup() {
    echo 1 > /proc/sys/net/ipv4/ip_forward
}

function vpn_connect() {
    openvpn $ovpnconfig
}

function firewall_setup() {
    iptables -t nat -A POSTROUTING -o $forward -j MASQUERADE
    iptables -A INPUT -i $listen -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -i $forward -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -j ACCEPT
}

function go_time() {
    echo -n "Go Time!\n"
}

system_setup
vpn_connect
firewall_setup
go_time
