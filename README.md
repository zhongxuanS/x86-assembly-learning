# 介绍
本仓库是《x86汇编语言-从实模式到保护模式》一书中的源代码，章节对应代码和pdf都在相关目录下

# 编译指令
nasm -f bin c05_mbr.asm -o mbr.bin

VBoxManage convertfromraw mbr.bin myfile.vhd --format VHD

# 这本书写的很不错，电子版只是方便阅读，还请大家购买实体书支持作者