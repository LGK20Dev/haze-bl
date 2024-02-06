ARMTOOLPREFIX?=arm-linux-gnueabihf-
ARM64TOOLPREFIX?=aarch64-linux-gnu-

DEVICE?=none
ARCH?=none

# For haze_boot.img, optional
FDT?=none
RAMDISK?=none

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

ifeq ($(strip $(TOOLPREFIX)),)
$(error Please specify a correct ARCH, or a correct DEVICE)
endif

$(info DEVICE=$(DEVICE))
$(info ARCH=$(ARCH))
$(info TOOLPREFIX=$(TOOLPREFIX))

# DO NOT CHANGE THIS DIRECTLY
# unless you know what you're doing
CC=$(TOOLPREFIX)gcc
CPP=$(TOOLPREFIX)cpp
LD=$(TOOLPREFIX)ld
OBJCPY=$(TOOLPREFIX)objcopy

haze_boot.img: haze
ifeq ($(shell test -e ./scripts/$(DEVICE)/postbuild.sh && echo -n yes),yes)
		$(info "Running $(DEVICE) postbuild script...")
		./scripts/$(DEVICE)/postbuild.sh $(FDT) $(RAMDISK)
endif

haze: hazebin
	$(OBJCPY) -O binary $< $@

hazebin: src/entry.o src/main.o src/linker/linker.lds
	$(LD) src/entry.o src/main.o -o $@ --script=src/linker/linker.lds

src/linker/linker.lds:
ifeq ($(ARCH), arm64)
	$(CPP) src/linker/linker.lds.S.aarch64 -P -o $@
endif

ifeq ($(ARCH), arm)
	$(CPP) src/linker/linker.lds.S.arm -P -o $@
endif

clean:
	rm -fv src/*.o src/linker/linker.lds
