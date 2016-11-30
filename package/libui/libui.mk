##################################################
#
# libui
#
##################################################
LIBUI_VERSION = f56411fde197481c00ad950e1a545452d47efa55
LIBUI_SITE = $(call github,andlabs,libui,$(LIBUI_VERSION))
LIBUI_INSTALL_STAGING = YES
LIBUI_INSTALL_TARGET = YES
LIBUI_CONF_OPTS = -DCMAKE_INSTALL_PREFIX=/usr
LIBUI_DEPENDENCIES = libgtk3 host-pkgconf

$(eval $(cmake-package))

