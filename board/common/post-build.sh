#!/bin/sh
set -u
set -e

###########################################################
# bluetooth and wifi are disabled by default
# bluez5 installs the service in /etc
###########################################################
rm -f ${TARGET_DIR}/etc/systemd/system/bluetooth.target.wants/bluetooth.service

###########################################################
# Currently weston is not able to use scalable graphics
###########################################################
find ${TARGET_DIR}/usr/share/weston -name *.svg -delete
find ${TARGET_DIR}/usr/share/icons -name *.svg -delete

###########################################################
# Some systemd stuff can't be disabled at build time ... but is useless
###########################################################
find ${TARGET_DIR} -name *nspawn* -delete

