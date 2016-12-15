################################################################################
#
# php-mount
#
################################################################################

PHP_MOUNT_VERSION = e48e2430732f1abd5f6e84f35c6df140128baf79
PHP_MOUNT_SITE = $(call github,elephos,php-mount,$(PHP_MOUNT_VERSION))
PHP_MOUNT_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config
# phpize does the autoconf magic
PHP_MOUNT_DEPENDENCIES = php host-autoconf
PHP_MOUNT_LICENSE = PHP
PHP_MOUNT_LICENSE_FILES = LICENSE

define PHP_MOUNT_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

define PHP_MOUNT_POST_INSTALL_TARGET
	echo "extension=mount.so" > $(TARGET_DIR)/etc/php.d/mount.ini
endef

PHP_MOUNT_PRE_CONFIGURE_HOOKS += PHP_MOUNT_PHPIZE

PHP_MOUNT_POST_INSTALL_TARGET_HOOKS += PHP_MOUNT_POST_INSTALL_TARGET

$(eval $(autotools-package))
