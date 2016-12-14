elephos
======

elephos is a modified version of rpi-buildroot that generates a bleeding edge iot linux image for RPI2 and RPI3.

elephos comes bundled with hardly anything, among the most useful are:

  * systemd
  * dbus
  * sshd
  * NetworkManager
  * GTK3
  * Wayland
  * Broadway
  * mesa3d
  * PHP7
  * Weston

It produces a *tiny* image, which is ready to boot into a skinny desktop that looks like:

[![elephos](http://i.stack.imgur.com/oh909.png)](http://github.com/krakjoe/elephos)

building
=======

If you have several hours to waste and would like to build yourself:

    make rpi2_defconfig
    make

*Note: do not use -j switch for make; suitable number of jobs are started by buildroot automatically.*

This will yield an image in ```output/images``` which can be copied with ``dd``.

    dd if=path/to/img of=/dev/sdX bs=4M

messing
======

If you would like to add additional packages to your image:

    make rpi2_defconfig
	make menuconfig
	/* hack hack hack */
	make

*Note: menuconfig can be replaced by nconfig, or qconfig for different ui*

merging
======

If you have made changes that would benefit everbody, please make a pull request.

installing
=========

To install a released image:

    sudo dd if=path/to/img of=/dev/sdX bs=4M && sudo sync

At this point you have a non-persistent system: If you boot the device, changes you make will not be saved.

persisting
=========

For a persistent installation, elephos requires a formatted partition: To use a partition on the same media as the rootfs:

    fdisk /dev/sdX

To create a 1GB partition copy/paste:

	n
	p
	3
	
	+1G
	w

Then format the partition:

	mkfs.ext2 /dev/sdX3

Then mount the boot partition on the installation media, open ```cmdline.txt``` and change:

	eufs.disk=zram

To:

	eufs.disk=/dev/sdX3

You may also remove:

	eufs.size=32

As this only relates to zram disks.

*Note: remember to unmount the boot partition gracefully!*

FAQ
===

How do I make WiFi work ?
----------------------

WiFi firmware and drivers for the RPI are installed and ready to use, but to save power and processing the user space WPA supplicant is not enabled by default:

    sudo systemctl enable wpa_supplicant
	sudo systemctl enable wpa_supplicant@wlan0
    sudo systemctl start wpa_supplicant
	sudo systemctl start wpa_supplicant@wlan0

At this point, WiFi should be ready to go, ```wps_cli``` and ```wpa_passphrase``` are installed to confgure connections.

How do I make bluetooth work ?
---------------------------

Bluetooth firmware and drivers for the RPI are installed and ready to use, but to save power and processing they are not enabled by default:

	sudo systemctl enable brcmfw
	sudo systemctl enable bluetooth
	sudo systemctl start brcmfw
	sudo systemctl start bluetooth

The ```bluetoothctl``` tool is installed to configure the device.

credits
======

As already mentioned, this is a modified version of rpi-buildroot, which itself is a modified version of buildroot.
