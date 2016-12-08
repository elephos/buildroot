#
#
#
#
#

DTC_DEPENDENCIES = libfdt
DTC_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

ifeq ($(BR2_LINUX_KERNEL_CUSTOM_TARBALL),y)
	DTC_TARBALL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
	DTC_SITE = $(patsubst %/,%,$(dir $(DTC_TARBALL)))
	DTC_SOURCE = $(notdir $(DTC_TARBALL))
	BR_NO_CHECK_HASH_FOR += $(DTC_SOURCE)
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_LOCAL),y)
	DTC_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_LOCAL_PATH))
	DTC_SITE_METHOD = local
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_GIT),y)
	DTC_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
	DTC_SITE_METHOD = git
	DTC_SOURCE = linux-$(DTC_VERSION).tar.gz
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_HG),y)
	DTC_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
	DTC_SITE_METHOD = hg
	DTC_SOURCE = linux-$(DTC_VERSION).tar.gz
else
	DTC_SOURCE = linux-$(DTC_VERSION).tar.xz
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_VERSION),y)
	BR_NO_CHECK_HASH_FOR += $(DTC_SOURCE)
endif
# In X.Y.Z, get X and Y. We replace dots and dashes by spaces in order
# to use the $(word) function. We support versions such as 4.0, 3.1,
# 2.6.32, 2.6.32-rc1, 3.0-rc6, etc.
ifeq ($(findstring x2.6.,x$(DTC_VERSION)),x2.6.)
	DTC_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v2.6
else ifeq ($(findstring x3.,x$(DTC_VERSION)),x3.)
	DTC_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v3.x
else ifeq ($(findstring x4.,x$(DTC_VERSION)),x4.)
	DTC_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v4.x
endif
# release candidates are in testing/ subdir
ifneq ($(findstring -rc,$(DTC_VERSION)),)
	DTC_SITE := $(DTC_SITE)/testing
endif # -rc
endif

DTC_PATCHES = $(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

# We rely on the generic package infrastructure to download and apply
# remote patches (downloaded from ftp, http or https). For local
# patches, we can't rely on that infrastructure, because there might
# be directories in the patch list (unlike for other packages).
DTC_PATCH = $(filter ftp://% http://% https://%,$(DTC_PATCHES))

define DTC_APPLY_LOCAL_PATCHES
        for p in $(filter-out ftp://% http://% https://%,$(DTC_PATCHES)) ; do \
                if test -d $$p ; then \
                        $(APPLY_PATCHES) $(@D) $$p \*.patch || exit 1 ; \
                else \
                        $(APPLY_PATCHES) $(@D) `dirname $$p` `basename $$p` || exit 1; \
                fi \
        done
endef

DTC_POST_PATCH_HOOKS += DTC_APPLY_LOCAL_PATCHES

define DTC_BUILD_CMDS
	$(Q)$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(LINUX_DIR)/scripts/dtc -o $(LINUX_DIR)/lib/dtc \
			$(LINUX_DIR)/scripts/dtc/checks.c \
			$(LINUX_DIR)/scripts/dtc/data.c \
			$(LINUX_DIR)/scripts/dtc/fstree.c \
			$(LINUX_DIR)/scripts/dtc/flattree.c \
			$(LINUX_DIR)/scripts/dtc/livetree.c \
			$(LINUX_DIR)/scripts/dtc/srcpos.c \
			$(LINUX_DIR)/scripts/dtc/treesource.c \
			$(LINUX_DIR)/scripts/dtc/util.c \
			$(LINUX_DIR)/scripts/dtc/dtc-lexer.lex.c \
			$(LINUX_DIR)/scripts/dtc/dtc-parser.tab.c \
			$(LINUX_DIR)/scripts/dtc/dtc.c \
		-I$(STAGING_DIR)/include -L$(STAGING_DIR)/lib -lfdt;
	$(Q)if [ $${?} -eq 0 ]; then \
		echo "  BUILD scripts/dtc/dtc.c OK"; \
	else \
		echo "  BUILD scripts/dtc/dtc.c FAILED"; \
	fi
endef

define DTC_INSTALL_TARGET_CMDS
	$(Q)$(INSTALL) -D $(LINUX_DIR)/lib/dtc $(TARGET_DIR)/bin/dtc
	$(Q)if [ $${?} -eq 0 ]; then \
		echo "  INSTALL bin/dtc OK"; \
	else \
		echo "  INSTALL bin/dtc FAILED"; \
	fi
	@for HEADER in `find $(LINUX_DIR)/include/dt-bindings -type f -printf '%P\n'`; \
	do \
		$(INSTALL) -D \
			$(LINUX_DIR)/include/dt-bindings/$${HEADER} \
			$(TARGET_DIR)/usr/share/dt-bindings/$${HEADER}; \
		if [ $${?} -eq 0 ]; then \
			echo "  INSTALL share/dt-bindings/$${HEADER} OK"; \
		else \
			echo "  INSTALL share/dt-bindings/$${HEADER} FAILED"; \
		fi \
	done
endef

$(eval $(generic-package))
