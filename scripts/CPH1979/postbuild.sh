#!/bin/bash

# mkbootimg offsets
BASE="0x40078000"
KERNEL="0x00008000"
RAMDISK="0x11b88000"
SECOND="0x00e88000"
TAGS="0x17288000"
HEADER="1"
OSVER="9.0.0"
PATCHLEVEL="2019-06"
CMDLINE="bootopt=64S3,32N2,64N2 buildvariant=user"

# Bootloader quirk
dtb_offset="10881706" # 0xA60AAA

check_files() 
{
    echo $0
    echo "$1"
    echo "$2"
    if [ ! -f "$1" ]; then
        echo "Your fdt blob is incorrect. Please provide a correct fdt blob to the makefile. Stop."
        exit 1
    fi

    if [ ! -f $2 ]; then
        echo "Your ramdisk is incorrect. Please provide a correct ramdisk to the makefile. Stop."
        exit 2
    fi

    if [ ! -x "$(command -v mkbootimg)" ]; then
        echo 'mkbootimg is not in path. Stop.'
        exit 3
    fi
}

gzip_kernel()
{
    gzip -n9 hazebin
}

append_dtb()
{
    # OPPO Bootloader Quirk
    dd if=$1 of=hazebin.gz bs=1 seek=$dtb_offset conv=notrunc
}

make_bootimg()
{
    echo mkbootimg --kernel hazebin.gz --ramdisk $2 --base $BASE --kernel_offset $KERNEL --ramdisk_offset $RAMDISK --second_offset $SECOND --tags_offset $TAGS --header_version $HEADER -o haze_boot.img
    mkbootimg --kernel hazebin.gz --ramdisk $2 --base $BASE --kernel_offset $KERNEL --ramdisk_offset $RAMDISK --second_offset $SECOND --tags_offset $TAGS --header_version $HEADER --os_version $OSVER --os_patch_level $PATCHLEVEL --cmdline "$CMDLINE" -o haze_boot.img
}

ls
check_files "$1" "$2"
gzip_kernel
append_dtb "$1" "$2"
make_bootimg "$1" "$2"
echo "All done. Good luck, have fun."