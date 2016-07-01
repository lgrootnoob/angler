echo BUILD SCRIPT .3

##### Define functions
bldk () {
echo __________________________
echo Kernel build
make -j8 || finish "failed" && return
finish "success"
}

finish () {
echo ___________________
if [ $1 = "failed" ]
then
echo Build Fail.
else
echo Build Success.

#echo Building Standard boot image for Android 6.0
#cp arch/arm/boot/zImage scripts/temp
#cd scripts/temp
#abootimg -u ../../boot.img -f bootimg.cfg -k zImage -r ramdisk.img
#rm zImage
#cd ../../
echo Creating AnyKernel2 zip
cp arch/arm64/boot/zImage scripts/temp/AnyKernel2
cd scripts/temp/AnyKernel2
zip -r9 UPDATE-AnyKernel2.zip * -x README UPDATE-AnyKernel2.zip
mv UPDATE-AnyKernel2.zip ../../../
rm zImage
cd ../../../
echo ___________________
echo Install UPDATE-AnyKernel2.zip
fi
return
}

##### Declare env vars and set bash color codes
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

varsnotset=false
grep -q "eabi" <<< "$PATH" || varsnotset=true
if [ "true" = "$varsnotset" ]
then
echo Setting vars.
export SUBARCH=arm64 ARCH=arm64 CROSS_COMPILE=aarch64-linux-android- export PATH=$PATH:/home/jacob/aarch64-linux-android-4.9-kernel-linaro/bin/
else
echo Env vars already set.
fi

##### Compilation pivot point
if [ $1 = "cfg" ]; then
make -j8 menuconfig && return
fi
if [ -e .config ]
then
# Kernel builds here with bldk
echo .config exists && bldk
return
else
echo ___________________________
make elementalx_defconfig
echo ___________________________
return
fi
