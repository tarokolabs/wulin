#!/bin/bash

[ -d /home/bigred/nn ] && chown -R bigred:bigred /home/bigred/nn
[ -d /home/bigred/sn ] && chown -R bigred:bigred /home/bigred/sn
[ -d /home/bigred/dn ] && chown -R bigred:bigred /home/bigred/dn

sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1

mount --make-rshared / &>/dev/null

[ -f /opt/zfs/sys/uslkh.bash ] && source /opt/zfs/sys/uslkh.bash
