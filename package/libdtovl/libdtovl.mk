##################################################
#
# libdtovl
#
##################################################
LIBDTOVL_VERSION = ed9016bfdffa6e88bcc5579a871bba164e251d82
LIBDTOVL_SITE = $(call github,elephos,libdtovl,$(LIBDTOVL_VERSION))
LIBDTOVL_INSTALL_STAGING = YES
LIBDTOVL_INSTALL_TARGET = YES
LIBDTOVL_CONF_OPTS = -DCMAKE_INSTALL_PREFIX=/usr
LIBDTOVL_DEPENDENCIES = libfdt host-pkgconf

$(eval $(cmake-package))

