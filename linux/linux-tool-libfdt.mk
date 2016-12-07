################################################################################
#
# libfdt
#
################################################################################

LINUX_TOOLS += libfdt

define LIBFDT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(LINUX_DIR)/scripts/dtc/libfdt  -shared -o $(LINUX_DIR)/lib/libfdt.so \
			$(LINUX_DIR)/scripts/dtc/libfdt/fdt.c \
			$(LINUX_DIR)/scripts/dtc/libfdt/fdt_empty_tree.c \
			$(LINUX_DIR)/scripts/dtc/libfdt/fdt_ro.c \
			$(LINUX_DIR)/scripts/dtc/libfdt/fdt_rw.c \
			$(LINUX_DIR)/scripts/dtc/libfdt/fdt_strerror.c \
			$(LINUX_DIR)/scripts/dtc/libfdt/fdt_sw.c \
			$(LINUX_DIR)/scripts/dtc/libfdt/fdt_wip.c;
endef

define LIBFDT_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(LINUX_DIR)/lib/libfdt.so $(STAGING_DIR)/lib/libfdt.so
	$(INSTALL) -D $(LINUX_DIR)/scripts/dtc/libfdt/fdt.h $(STAGING_DIR)/include/fdt.h
	$(INSTALL) -D $(LINUX_DIR)/scripts/dtc/libfdt/libfdt.h $(STAGING_DIR)/include/libfdt.h
	$(INSTALL) -D $(LINUX_DIR)/scripts/dtc/libfdt/libfdt_env.h $(STAGING_DIR)/include/libfdt_env.h
endef

define LIBFDT_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(LINUX_DIR)/lib/libfdt.so $(TARGET_DIR)/lib/libfdt.so
endef


