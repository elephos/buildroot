################################################################################
#
# php-uv
#
################################################################################

PHP_UV_VERSION = v0.1.1
PHP_UV_SITE = $(call github,bwoebi,php-uv,$(PHP_UV_VERSION))
PHP_UV_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-ui=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_UV_DEPENDENCIES = libuv php host-autoconf
PHP_UV_LICENSE = PHP
PHP_UV_LICENSE_FILES = LICENSE

define PHP_UV_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

define PHP_UV_POST_INSTALL_TARGET
	echo "extension=uv.so" > $(TARGET_DIR)/etc/php.d/uv.ini
endef

PHP_UV_PRE_CONFIGURE_HOOKS += PHP_UV_PHPIZE

PHP_UV_POST_INSTALL_TARGET_HOOKS += PHP_UV_POST_INSTALL_TARGET

$(eval $(autotools-package))
