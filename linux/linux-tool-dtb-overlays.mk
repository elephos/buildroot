################################################################################
#
# dtb-overlays
#
################################################################################

LINUX_TOOLS += dtb-overlays

DTB_OVERLAYS_SRC = $(KERNEL_ARCH_PATH)/boot/dts/overlays
DTB_OVERLAYS_DST = $(BINARIES_DIR)/boot/overlays

define DTB_OVERLAYS_BUILD_CMDS
	$(Q)for dtbo in $(DTB_OVERLAYS_SRC)/*overlay.dts; do \
		ovname=`basename $$(echo $${dtbo} | sed 's/-overlay.dts/.dtbo/')`; \
		cd $(LINUX_DIR) && \
			$(HOST_DIR)/usr/bin/dtc -q -I dts -O dtb \
				$${dtbo} -o $(DTB_OVERLAYS_SRC)/$${ovname}; \
		if [ $${?} -eq 0 ]; then \
			echo "  BUILD boot/dts/overlays/$${ovname}-overlay.dts OK"; \
		else \
			echo "  BUILD boot/dts/overlays/$${ovname}-overlay.dts FAILED"; \
		fi \
	done
endef

define DTB_OVERLAYS_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(DTB_OVERLAYS_SRC)/README $(DTB_OVERLAYS_DST)/README
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


