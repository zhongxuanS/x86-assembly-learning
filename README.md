本仓库是《x86汇编语言-从实模式到保护模式》一书中的源代码，章节对应代码和pdf都在相关目录下

nasm -f bin c05_mbr.asm -o mbr.bin

VBoxManage convertfromraw mbr.bin myfile.vhd --format VHD
