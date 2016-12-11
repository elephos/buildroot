elephos
======

elephos is a modified version of rpi-buildroot that generates a bleeding edge iot linux image for RPI2 and RPI3.

elephos comes bundled with hardly anything, among the most useful are:

  * systemd
  * dbus
  * GTK3
  * Wayland
  * Broadway
  * mesa3d
  * PHP7
  * Weston

It produces a tiny image (~150mb), which is ready to boot into a skinny desktop that looks like:

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

    sudo dd if=path/to/img of=/dev/sdX bs=4M

At this point you have a usable system, and could boot the device (after sync). However, there is only a small amount of persistent storage available. 

To resize the persistent (user) storage partition:

	sudo support/scripts/resize-user /dev/sdX [size]

Replace ```/dev/sdX``` with the name of the target device, **do not include the partition number**.

Size should be in the form ```+1G``` for ```1GB```, the value is passed to ```fdisk``` as partition boundaries. If no size is given, the maximum space is used.

*Note: At present rpi2 and rpi3 are different images.*


FAQ
===

How do I make WiFi work ?
----------------------

WiFi firmware and drivers for the RPI are installed and ready to use, but to save power and processing they are not enabled by default:

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
