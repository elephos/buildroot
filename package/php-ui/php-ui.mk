################################################################################
#
# php-ui
#
################################################################################

PHP_UI_VERSION = a7020afbb6d5c948c25021329277f849ee4610f6
PHP_UI_SITE = $(call github,krakjoe,ui,$(PHP_UI_VERSION))
PHP_UI_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-ui=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_UI_DEPENDENCIES = php host-autoconf
PHP_UI_LICENSE = PHP
PHP_UI_LICENSE_FILES = LICENSE

define PHP_UI_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

define PHP_UI_POST_INSTALL_TARGET
	echo "extension=ui.so" > $(TARGET_DIR)/etc/php.d/ui.ini
endef

PHP_UI_PRE_CONFIGURE_HOOKS += PHP_UI_PHPIZE

PHP_UI_POST_INSTALL_TARGET_HOOKS += PHP_UI_POST_INSTALL_TARGET

$(eval $(autotools-package))
