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

USER_DIR="board/common/user"
USER_CFG="board/common/user.cfg"
USER_TMP="board/common/user.tmp"

rm -rf "${GENIMAGE_TMP}" 2>/dev/null
rm -rf "${USER_TMP}" 2>/dev/null

genimage                           \
	--rootpath "${USER_DIR}"    \
	--tmppath  "${USER_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${USER_CFG}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

ESTATUS=$?

rm -rf "${GENIMAGE_TMP}" 2>/dev/null
rm -rf "${USER_TMP}" 2>/dev/null

exit $ESTATUS
