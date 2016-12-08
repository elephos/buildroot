#
#
#
#
#

LIBFDT_DEPENDENCIES = linux
LIBFDT_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

ifeq ($(BR2_LINUX_KERNEL_CUSTOM_TARBALL),y)
	LIBFDT_TARBALL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
	LIBFDT_SITE = $(patsubst %/,%,$(dir $(LIBFDT_TARBALL)))
	LIBFDT_SOURCE = $(notdir $(LIBFDT_TARBALL))
	BR_NO_CHECK_HASH_FOR += $(LIBFDT_SOURCE)
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_LOCAL),y)
	LIBFDT_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_LOCAL_PATH))
	LIBFDT_SITE_METHOD = local
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_GIT),y)
	LIBFDT_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
	LIBFDT_SITE_METHOD = git
	LIBFDT_SOURCE = linux-$(LIBFDT_VERSION).tar.gz
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_HG),y)
	LIBFDT_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
	LIBFDT_SITE_METHOD = hg
	LIBFDT_SOURCE = linux-$(LIBFDT_VERSION).tar.gz
else
	LIBFDT_SOURCE = linux-$(LIBFDT_VERSION).tar.xz
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_VERSION),y)
	BR_NO_CHECK_HASH_FOR += $(LIBFDT_SOURCE)
endif
# In X.Y.Z, get X and Y. We replace dots and dashes by spaces in order
# to use the $(word) function. We support versions such as 4.0, 3.1,
# 2.6.32, 2.6.32-rc1, 3.0-rc6, etc.
ifeq ($(findstring x2.6.,x$(LIBFDT_VERSION)),x2.6.)
	LIBFDT_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v2.6
else ifeq ($(findstring x3.,x$(LIBFDT_VERSION)),x3.)
	LIBFDT_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v3.x
else ifeq ($(findstring x4.,x$(LIBFDT_VERSION)),x4.)
	LIBFDT_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v4.x
endif
# release candidates are in testing/ subdir
ifneq ($(findstring -rc,$(LIBFDT_VERSION)),)
	LIBFDT_SITE := $(LIBFDT_SITE)/testing
endif # -rc
endif

LIBFDT_PATCHES += $(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

# We rely on the generic package infrastructure to download and apply
# remote patches (downloaded from ftp, http or https). For local
# patches, we can't rely on that infrastructure, because there might
# be directories in the patch list (unlike for other packages).
LIBFDT_PATCH = $(filter ftp://% http://% https://%,$(LIBFDT_PATCHES))

define LIBFDT_APPLY_LOCAL_PATCHES
        for p in $(filter-out ftp://% http://% https://%,$(LIBFDT_PATCHES)) ; do \
                if test -d $$p ; then \
                        $(APPLY_PATCHES) $(@D) $$p \*.patch || exit 1 ; \
                else \
                        $(APPLY_PATCHES) $(@D) `dirname $$p` `basename $$p` || exit 1; \
                fi \
        done
endef

LIBFDT_POST_PATCH_HOOKS += LIBFDT_APPLY_LOCAL_PATCHES

LIBFDT_INSTALL_STAGING = YES

define LIBFDT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(@D)/scripts/dtc/libfdt  -shared -o $(@D)/libfdt.so \
			$(@D)/scripts/dtc/libfdt/fdt.c \
			$(@D)/scripts/dtc/libfdt/fdt_empty_tree.c \
			$(@D)/scripts/dtc/libfdt/fdt_ro.c \
			$(@D)/scripts/dtc/libfdt/fdt_rw.c \
			$(@D)/scripts/dtc/libfdt/fdt_strerror.c \
			$(@D)/scripts/dtc/libfdt/fdt_sw.c \
			$(@D)/scripts/dtc/libfdt/fdt_wip.c;
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(@D)/scripts/dtc -I$(@D)/scripts/dtc/libfdt \
			-L$(@D) -o $(@D)/fdtdump \
			$(@D)/scripts/dtc/util.c \
			$(@D)/scripts/dtc/fdtdump.c \
		-lfdt;
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(@D)/scripts/dtc -I$(@D)/scripts/dtc/libfdt \
			-L$(@D) -o $(@D)/fdtput \
			$(@D)/scripts/dtc/util.c \
			$(@D)/scripts/dtc/fdtput.c \
		-lfdt;
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(@D)/scripts/dtc -I$(@D)/scripts/dtc/libfdt \
			-L$(@D) -o $(@D)/fdtget \
			$(@D)/scripts/dtc/util.c \
			$(@D)/scripts/dtc/fdtget.c \
		-lfdt;
endef

define LIBFDT_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(@D)/libfdt.so $(STAGING_DIR)/lib/libfdt.so
	$(INSTALL) -D $(@D)/scripts/dtc/libfdt/fdt.h $(STAGING_DIR)/include/fdt.h
	$(INSTALL) -D $(@D)/scripts/dtc/libfdt/libfdt.h $(STAGING_DIR)/include/libfdt.h
	$(INSTALL) -D $(@D)/scripts/dtc/libfdt/libfdt_env.h $(STAGING_DIR)/include/libfdt_env.h
endef

define LIBFDT_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/libfdt.so $(TARGET_DIR)/lib/libfdt.so
	$(INSTALL) -D $(@D)/fdtdump   $(TARGET_DIR)/bin/fdtdump
	$(INSTALL) -D $(@D)/fdtput    $(TARGET_DIR)/bin/fdtput
	$(INSTALL) -D $(@D)/fdtget    $(TARGET_DIR)/bin/fdtget
endef

$(eval $(generic-package))
