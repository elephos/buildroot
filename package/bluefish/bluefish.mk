##################################################
#
# bluefish
#
##################################################
BLUEFISH_VERSION = 2.2.9
BLUEFISH_SOURCE = bluefish-$(BLUEFISH_VERSION).tar.gz
BLUEFISH_SITE = http://www.bennewitz.com/bluefish/stable/source
BLUEFISH_INSTALL_STAGING = NO
BLUEFISH_INSTALL_TARGET = YES
BLUEFISH_DEPENDENCIES = libgtk3
BLUEFISH_AUTORECONF = YES
BLUEFISH_CONF_OPTS += --disable-spell --disable-schemas-compile --disable-python

$(eval $(autotools-package))

