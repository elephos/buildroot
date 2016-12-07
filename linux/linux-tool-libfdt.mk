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
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(LINUX_DIR)/scripts/dtc -o $(LINUX_DIR)/lib/fdtdump \
			$(LINUX_DIR)/scripts/dtc/util.c \
			$(LINUX_DIR)/scripts/dtc/fdtdump.c \
		-lfdt;
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(LINUX_DIR)/scripts/dtc -o $(LINUX_DIR)/lib/fdtput \
			$(LINUX_DIR)/scripts/dtc/util.c \
			$(LINUX_DIR)/scripts/dtc/fdtput.c \
		-lfdt;
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(LINUX_DIR)/scripts/dtc -o $(LINUX_DIR)/lib/fdtget \
			$(LINUX_DIR)/scripts/dtc/util.c \
			$(LINUX_DIR)/scripts/dtc/fdtget.c \
		-lfdt;
endef

define LIBFDT_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(LINUX_DIR)/lib/libfdt.so $(STAGING_DIR)/lib/libfdt.so
	$(INSTALL) -D $(LINUX_DIR)/scripts/dtc/libfdt/fdt.h $(STAGING_DIR)/include/fdt.h
	$(INSTALL) -D $(LINUX_DIR)/scripts/dtc/libfdt/libfdt.h $(STAGING_DIR)/include/libfdt.h
	$(INSTALL) -D $(LINUX_DIR)/scripts/dtc/libfdt/libfdt_env.h $(STAGING_DIR)/include/libfdt_env.h
endef

define LIBFDT_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(LINUX_DIR)/lib/libfdt.so $(TARGET_DIR)/lib/libfdt.so
	$(INSTALL) -D $(LINUX_DIR)/lib/fdtdump $(TARGET_DIR)/bin/fdtdump
	$(INSTALL) -D $(LINUX_DIR)/lib/fdtput $(TARGET_DIR)/bin/fdtput
	$(INSTALL) -D $(LINUX_DIR)/lib/fdtget $(TARGET_DIR)/bin/fdtget
endef


