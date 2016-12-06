################################################################################
#
# rpi-firmware
#
################################################################################

RPI_FIRMWARE_VERSION = d760a4ffd378c648ff5d9854e26dc868a5e1fd09
RPI_FIRMWARE_SITE = $(call github,raspberrypi,firmware,$(RPI_FIRMWARE_VERSION))
RPI_FIRMWARE_LICENSE = BSD-3c
RPI_FIRMWARE_LICENSE_FILES = boot/LICENCE.broadcom
RPI_FIRMWARE_INSTALL_IMAGES = YES

RPI_FIRMWARE_DEPENDENCIES += host-rpi-firmware

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_VCDBG),y)
define RPI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0700 $(@D)/$(if BR2_ARM_EABIHF,hardfp/)opt/vc/bin/vcdbg \
		$(TARGET_DIR)/usr/sbin/vcdbg
endef
endif # INSTALL_VCDBG

define RPI_FIRMWARE_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/boot/bootcode.bin $(BINARIES_DIR)/boot/bootcode.bin
	$(INSTALL) -D -m 0644 $(@D)/boot/start$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).elf $(BINARIES_DIR)/boot/start.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).dat $(BINARIES_DIR)/boot/fixup.dat
endef

# We have no host sources to get, since we already
# bundle the script we want to install.
HOST_RPI_FIRMWARE_SOURCE =

define HOST_RPI_FIRMWARE_INSTALL_CMDS
	$(INSTALL) -D -m 0755 package/rpi-firmware/mkknlimg $(HOST_DIR)/usr/bin/mkknlimg
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
