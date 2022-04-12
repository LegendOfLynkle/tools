#!/bin/bash

# Settings the defaults ideal for OSCP/HTB etc.
listen="eth0"
forward="tun0"

while getopts l:f: flag
do
	case "${flag}" in
		l) listen=${OPTARG};;
		f) forward=${OPTARG};;
	esac
done

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o $forward -j MASQUERADE
iptables -A INPUT -i $listen -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $forward -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -j ACCEPT
