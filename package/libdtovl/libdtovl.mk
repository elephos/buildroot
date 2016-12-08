##################################################
#
# libdtovl
#
##################################################
LIBDTOVL_VERSION = d775b8e9f5a948562a0b564fa43097afba46b2cb
LIBDTOVL_SITE = $(call github,elephos,libdtovl,$(LIBDTOVL_VERSION))
LIBDTOVL_INSTALL_STAGING = YES
LIBDTOVL_INSTALL_TARGET = YES
LIBDTOVL_CONF_OPTS = -DCMAKE_INSTALL_PREFIX=/usr
LIBDTOVL_DEPENDENCIES = libfdt host-pkgconf

$(eval $(cmake-package))

