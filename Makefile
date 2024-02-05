ARMTOOLPREFIX?=arm-linux-gnueabihf-
ARM64TOOLPREFIX?=aarch64-linux-gnu-

ARMCC=$(ARMTOOLPREFIX)gcc
ARMCPP=$(ARMTOOLPREFIX)cpp
ARMLD=$(ARMTOOLPREFIX)ld

ARM64CC=$(ARM64TOOLPREFIX)gcc
ARM64CPP=$(ARM64TOOLPREFIX)cpp
ARM64LD=$(ARM64TOOLPREFIX)ld

arm: entry.o main.o linker.lds.arm
	$(ARMLD) entry.o main.o -o haze --script=linker.lds

arm64: entry.o main.o linker.lds.aarch64
	$(ARM64LD) entry.o main.o -o haze --script=linker.lds

linker.lds.aarch64: linker.lds.S.aarch64
	$(ARM64CPP) $< -P -o linker.lds

linker.lds.arm: linker.lds.S.arm
	$(ARMCPP) $< -P -o linker.lds
