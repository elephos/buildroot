################################################################################
#
# dtc
#
################################################################################

LINUX_TOOLS += dtc

define DTC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
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
		-lfdt;
endef

define DTC_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(LINUX_DIR)/lib/dtc $(TARGET_DIR)/bin/dtc
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


