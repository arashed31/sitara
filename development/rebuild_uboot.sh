#!/bin/sh -e
# am335x_evm_defconfig
# am43xx_evm_defconfig
# am57xx_evm_defconfig
# dra7xx_evm_defconfig
# omap5_uevm_defconfig
# k2e_evm_defconfig
# k2g_evm_defconfig

if [ "$1" = "help" ]; then
	echo "Use git to checkout a TI U-Boot Release tag"
	echo "example: git checkout ti2018.01"
	echo "Then send the SoC part of <soc>_evm_defconfig to the script"
	echo "see configs/ directory for additional options"
	echo "\tam335x\n\tam43xx\n\tam57xx\n\tdra7xx\n\tomap5\n\tk2e\n\tk2g"
	exit
fi

export DEVICE=$1
export VERSION=$(cat .git/logs/HEAD | tail -c 10)

export FOLDER=../built/${DEVICE}_${VERSION}

export CONFIG=defconfig
if [ "$2" = "emmc" ]; then
	export CONFIG=emmc_defconfig
elif [ "$2" = "usb" ]; then
	export CONFIG=usb_defconfig
fi

if [ "$DEVICE" = "omap5" ]; then
	export DEFCONFIG=${DEVICE}_uevm_${CONFIG}
else
	export DEFCONFIG=${DEVICE}_evm_${CONFIG}
fi

export ARCH=arm
export CROSS_COMPILE=~/gcc-linaro-6.2.1/bin/arm-linux-gnueabihf-
export CORES=$(getconf _NPROCESSORS_ONLN)

echo -e "export ARCH=$ARCH\nexport CROSS_COMPILE=$CROSS_COMPILE\nexport DEVICE=$DEVICE\nexport DEFCONFIG=$DEFCONFIG\nexport VERSION=$VERSION\nexport FOLDER=$FOLDER"
make distclean
#make O=$FOLDER distclean
#make O=$FOLDER $DEFCONFIG
make O=$FOLDER -j$CORES
