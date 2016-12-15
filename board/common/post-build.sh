#!/bin/sh
set -u
set -e

###########################################################
# Currently weston is not able to use scalable graphics
###########################################################
find ${TARGET_DIR}/usr/share/weston -name *.svg -delete
find ${TARGET_DIR}/usr/share/icons -name *.svg -delete

###########################################################
# Some systemd stuff can't be disabled at build time ... but is useless
###########################################################
find ${TARGET_DIR} -name *nspawn* -delete

