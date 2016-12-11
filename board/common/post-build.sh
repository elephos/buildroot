#!/bin/sh
set -u
set -e

###########################################################
# elephos does not use getty target
###########################################################
rm -rf ${TARGET_DIR}/etc/systemd/system/getty.target.wants

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




