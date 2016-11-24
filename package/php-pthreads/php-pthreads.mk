################################################################################
#
# php-pthreads
#
################################################################################

PHP_PTHREADS_VERSION = 959ab0ff5fbd59d29a9d77f0309065cdfe62531f
PHP_PTHREADS_SITE = $(call github,krakjoe,pthreads,$(PHP_PTHREADS_VERSION))
PHP_PTHREADS_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config
# phpize does the autoconf magic
PHP_PTHREADS_DEPENDENCIES = php host-autoconf
PHP_PTHREADS_LICENSE = PHP
PHP_PTHREADS_LICENSE_FILES = LICENSE

define PHP_PTHREADS_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

define PHP_PTHREADS_POST_INSTALL_TARGET
	echo "extension=pthreads.so" > $(TARGET_DIR)/etc/php.d/pthreads.ini
endef

PHP_PTHREADS_PRE_CONFIGURE_HOOKS += PHP_PTHREADS_PHPIZE

PHP_PTHREADS_POST_INSTALL_TARGET_HOOKS += PHP_PTHREADS_POST_INSTALL_TARGET

$(eval $(autotools-package))
