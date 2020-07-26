These are floppy disk and CD-ROM images containing MikeOS and accompanying programs.

You can use RAWRITE on WINDOWS or 'dd' on Linux to write floppy disk image to real floppy.
Alternatively, you can burn the .iso to a CD-R andnboot from it in your CD burning utility.

Note that the CD image is generated automatically from the build scripts,
and uses the floppy image as a boot block (a virtual floppy disk).

In Linux/Unix, you can create a new floppy image with this command: mkdosfs -C dummyos.flp 1440

The build-linux.sh script does this if it doesn't find dummyos.flp.
