TOOLPREFIX?=arm-linux-gnueabihf-
CC=$(TOOLPREFIX)gcc
CPP=$(TOOLPREFIX)cpp
LD=$(TOOLPREFIX)ld

arm: entry.o main.o linker.lds.arm
	$(LD) entry.o main.o -o haze --script=linker.lds

arm64: entry.o main.o linker.lds.aarch64
	$(LD) entry.o main.o -o haze --script=linker.lds

linker.lds.aarch64: linker.lds.S.aarch64
	$(CPP) $< -P -o linker.lds

linker.lds.arm: linker.lds.S.arm
	$(CPP) $< -P -o linker.lds
