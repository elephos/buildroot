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

```NetworkManager``` and ```WPA``` utils are installed to configure wifi, start with ```nmcli```.

How do I make bluetooth work ?
---------------------------

Bluetooth is not enabled by default, and needs to be started manually:

    sudo systemctl start bluetooth.target

Various ```HCI``` tools and ```bluetoothctl``` (bluez5) are installed.

credits
======

As already mentioned, this is a modified version of rpi-buildroot, which itself is a modified version of buildroot.
