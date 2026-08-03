#!/usr/bin/env bash

[ -d /home/bigred/nn ] && chown -R bigred:bigred /home/bigred/nn
[ -d /home/bigred/sn ] && chown -R bigred:bigred /home/bigred/sn
[ -d /home/bigred/dn ] && chown -R bigred:bigred /home/bigred/dn

sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>/dev/null
sysctl -w net.ipv6.conf.default.disable_ipv6=1 &>/dev/null
sysctl -w net.ipv6.conf.lo.disable_ipv6=1 &>/dev/null

mount --make-rshared /

