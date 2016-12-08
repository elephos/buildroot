#
#
#
#
#

DTBO_DEPENDENCIES = linux
DTBO_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

DTB_OVERLAYS_SRC = $(KERNEL_ARCH_PATH)/boot/dts/overlays
DTB_OVERLAYS_DST = $(BINARIES_DIR)/boot/overlays

ifeq ($(BR2_LINUX_KERNEL_CUSTOM_TARBALL),y)
	DTBO_TARBALL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
	DTBO_SITE = $(patsubst %/,%,$(dir $(DTBO_TARBALL)))
	DTBO_SOURCE = $(notdir $(DTBO_TARBALL))
	BR_NO_CHECK_HASH_FOR += $(DTBO_SOURCE)
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_LOCAL),y)
	DTBO_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_LOCAL_PATH))
	DTBO_SITE_METHOD = local
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_GIT),y)
	DTBO_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
	DTBO_SITE_METHOD = git
	DTBO_SOURCE = linux-$(DTBO_VERSION).tar.gz
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_HG),y)
	DTBO_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
	DTBO_SITE_METHOD = hg
	DTBO_SOURCE = linux-$(DTBO_VERSION).tar.gz
else
	DTBO_SOURCE = linux-$(DTBO_VERSION).tar.xz
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_VERSION),y)
	BR_NO_CHECK_HASH_FOR += $(DTBO_SOURCE)
endif
# In X.Y.Z, get X and Y. We replace dots and dashes by spaces in order
# to use the $(word) function. We support versions such as 4.0, 3.1,
# 2.6.32, 2.6.32-rc1, 3.0-rc6, etc.
ifeq ($(findstring x2.6.,x$(DTBO_VERSION)),x2.6.)
	DTBO_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v2.6
else ifeq ($(findstring x3.,x$(DTBO_VERSION)),x3.)
	DTBO_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v3.x
else ifeq ($(findstring x4.,x$(DTBO_VERSION)),x4.)
	DTBO_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v4.x
endif
# release candidates are in testing/ subdir
ifneq ($(findstring -rc,$(DTBO_VERSION)),)
	DTBO_SITE := $(DTBO_SITE)/testing
endif # -rc
endif

DTBO_PATCHES = $(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

# We rely on the generic package infrastructure to download and apply
# remote patches (downloaded from ftp, http or https). For local
# patches, we can't rely on that infrastructure, because there might
# be directories in the patch list (unlike for other packages).
DTBO_PATCH = $(filter ftp://% http://% https://%,$(DTBO_PATCHES))

define DTBO_APPLY_LOCAL_PATCHES
        for p in $(filter-out ftp://% http://% https://%,$(DTBO_PATCHES)) ; do \
                if test -d $$p ; then \
                        $(APPLY_PATCHES) $(@D) $$p \*.patch || exit 1 ; \
                else \
                        $(APPLY_PATCHES) $(@D) `dirname $$p` `basename $$p` || exit 1; \
                fi \
        done
endef

DTBO_POST_PATCH_HOOKS += DTBO_APPLY_LOCAL_PATCHES

define DTBO_BUILD_CMDS
	$(Q)for dtbo in $(DTB_OVERLAYS_SRC)/*overlay.dts; do \
		ovname=`basename $$(echo $${dtbo} | sed 's/-overlay.dts/.dtbo/')`; \
		cd $(LINUX_DIR) && \
			$(LINUX_DIR)/scripts/dtc/dtc -q -I dts -O dtb \
				$${dtbo} -o $(DTB_OVERLAYS_SRC)/$${ovname}; \
		if [ $${?} -eq 0 ]; then \
			echo "  BUILD boot/dts/overlays/$${ovname}-overlay.dts OK"; \
		else \
			echo "  BUILD boot/dts/overlays/$${ovname}-overlay.dts FAILED"; \
		fi \
	done
endef

define DTBO_INSTALL_TARGET_CMDS
	$(Q) $(INSTALL) -D $(DTB_OVERLAYS_SRC)/README $(DTB_OVERLAYS_DST)/README
	$(Q)for dtbo in $(DTB_OVERLAYS_SRC)/*.dtbo; do \
		ovname=`basename $${dtbo}`; \
		$(INSTALL) -m 0644 -D \
			$(DTB_OVERLAYS_SRC)/$${ovname} $(DTB_OVERLAYS_DST)/$${ovname}; \
		if [ $${?} -eq 0 ]; then \
			echo "  INSTALL boot/overlays/$${ovname} OK"; \
		else \
			echo "  INSTALL boot/overlays/$${ovname} FAILED"; \
		fi \
	done
endef

$(eval $(generic-package))
