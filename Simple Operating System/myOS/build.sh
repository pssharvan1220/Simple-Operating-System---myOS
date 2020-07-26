#!/bin/sh

# This script assembles the MikeOS bootloader, kernel and programs
# with NASM, and then creates floppy and CD images (on Linux)

if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e Disk_Images/myOS.flp ]
then
	echo ">>> Creating new MikeOS floppy image..."
	mkdosfs -C Disk_Images/myOS.flp 1440 || exit
fi


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o Source_Code/Boot_load/boot.bin Source_Code/Boot_load/boot.asm || exit


echo ">>> Assembling myOS kernel..."

cd Source_Code
nasm -O0 -w+orphan-labels -f bin -o KERNEL.bin KERNEL.asm || exit
cd ..


echo ">>> Assembling programs..."

echo ">>> Adding bootloader to floppy image..."

dd status=noxfer conv=notrunc if=Source_Code/Boot_load/boot.bin of=Disk_Images/myOS.flp || exit


echo ">>> Copying MikeOS kernel and programs..."

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat Disk_Images/myOS.flp tmp-loop && cp Source_Code/KERNEL.bin tmp-loop/



sleep 0.2

echo ">>> Unmounting loopback floppy..."

umount tmp-loop || exit

rm -rf tmp-loop


echo ">>> Creating CD-ROM ISO image..."

rm -f Disk_Images/myOS.iso
mkisofs -quiet -V 'MYOS' -input-charset iso8859-1 -o Disk_Images/myOS.iso -b myOS.flp Disk_Images/ || exit

echo '>>> Done!'
