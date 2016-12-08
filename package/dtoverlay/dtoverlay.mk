##################################################
#
# dtoverlay
#
##################################################
DTOVERLAY_VERSION = 83a35b7749084eeb258d7f5b3cea45242a360d26
DTOVERLAY_SITE = $(call github,elephos,dtoverlay,$(DTOVERLAY_VERSION))
DTOVERLAY_INSTALL_TARGET = YES
DTOVERLAY_CONF_OPTS = -DCMAKE_INSTALL_PREFIX=/usr
DTOVERLAY_DEPENDENCIES = host-pkgconf libdtovl

$(eval $(cmake-package))

