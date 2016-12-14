#!/bin/sh

GENIMAGE_RPI=rpi${2}

[ -d ${BINARIES_DIR}/boot/ ] || 					mkdir ${BINARIES_DIR}/boot/
[ -d ${BINARIES_DIR}/boot/${GENIMAGE_RPI} ] || 		mkdir ${BINARIES_DIR}/boot/${GENIMAGE_RPI}

# Mark the kernel as DT-enabled
${HOST_DIR}/usr/bin/mkknlimg --dtok --ddtk \
	"${BINARIES_DIR}/zImage" \
	"${BINARIES_DIR}/boot/zImage"

if [ ! -f ${BINARIES_DIR}/boot/cmdline.txt ]; then
	cp board/common/kernel.cmd \
		${BINARIES_DIR}/boot/cmdline.txt
fi

if [ ! -f ${BINARIES_DIR}/boot/${GENIMAGE_RPI}/config.txt ]; then
	cp board/${GENIMAGE_RPI}/kernel.cfg \
		${BINARIES_DIR}/boot/${GENIMAGE_RPI}/config.txt
fi

GENIMAGE_CFG="board/${GENIMAGE_RPI}/genimage.cfg"
GENIMAGE_TMP="board/${GENIMAGE_RPI}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}" 2>/dev/null

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

ESTATUS=$?

rm -rf "${GENIMAGE_TMP}" 2>/dev/null

exit $ESTATUS
