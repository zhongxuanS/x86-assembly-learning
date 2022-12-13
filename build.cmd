@echo off
set input_asm=%1
set output_vhd_dir=%2
set output_vhd_file_name=%3
nasm -f bin %input_asm% -o %output_vhd_dir%\123.bin
VBoxManage convertfromraw %output_vhd_dir%\123.bin %output_vhd_dir%\%output_vhd_file_name%.vhd --format VHD

del %output_vhd_dir%\123.bin /f /q