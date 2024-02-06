ARMTOOLPREFIX?=arm-linux-gnueabihf-
ARM64TOOLPREFIX?=aarch64-linux-gnu-

DEVICE?=none
ARCH?=none

# Improve this later
ifeq ($(DEVICE), CPH1979)
ARCH=arm64
endif

# Building for ARM
ifeq ($(ARCH), arm)
TOOLPREFIX=$(ARMTOOLPREFIX)
endif

# Building for ARM64
ifeq ($(ARCH), arm64)
TOOLPREFIX=$(ARM64TOOLPREFIX)
endif

$(info DEVICE=$(DEVICE))
$(info ARCH=$(ARCH))
$(info TOOLPREFIX=$(TOOLPREFIX))

ifeq ($(strip $(TOOLPREFIX)),)
$(error Please specify a correct ARCH, or a correct DEVICE)
endif

CC=$(TOOLPREFIX)gcc
CPP=$(TOOLPREFIX)cpp
LD=$(TOOLPREFIX)ld

hazebin: entry.o main.o linker.lds
	$(LD) entry.o main.o -o $@ --script=linker.lds

linker.lds:
ifeq ($(ARCH), arm64)
	$(CPP) linker.lds.S.aarch64 -P -o $@
endif

ifeq ($(ARCH), arm)
	$(CPP) linker.lds.S.arm -P -o $@
endif