elephos
======

elephos is a modified version of rpi-buildroot that generates a bleeding edge iot linux image for RPI2 and RPI3.

elephos comes bundled with hardly anything, among the most useful are:

  * systemd
  * dbus
  * GTK3
  * Wayland
  * Broadway
  * DirectFB
  * PHP7
  * Weston

It produces a tiny image (~250mb), which is ready to boot into a skinny desktop that looks like:

PUT IMAGE HERE

building
=======

If you have several hours to waste and would like to build yourself:

    make rpi2_defconfig
    make

*Note: do not use -j switch for make; suitable number of jobs are started by buildroot automatically.*

This will yield ```output/images/sdcard.img``` which can be copied with ``dd``.

    dd if=output/images/sdcard.img of=/dev/sdX bs=4M

Alternatively, executing ```board/raspberrypi/mksdcard /dev/sdX``` with the appropriate block device will perform repartition, format, and copy.

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

credits
======

As already mentioned, this is a modified version of rpi-buildroot, which itself is a modified version of buildroot.
