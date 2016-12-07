##################################################
#
# dtoverlay
#
##################################################
DTOVERLAY_VERSION = b4e59a698719639f30a45e4e812c8f10ef923300
DTOVERLAY_SITE = $(call github,elephos,dtoverlay,$(DTOVERLAY_VERSION))
DTOVERLAY_INSTALL_STAGING = YES
DTOVERLAY_INSTALL_TARGET = YES
DTOVERLAY_CONF_OPTS = -DCMAKE_INSTALL_PREFIX=/usr
DTOVERLAY_DEPENDENCIES = host-pkgconf libdtovl

$(eval $(cmake-package))

