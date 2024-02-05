TOOLPREFIX?=arm-linux-gnueabihf-
CC=$(TOOLPREFIX)gcc
CPP=$(TOOLPREFIX)cpp
LD=$(TOOLPREFIX)ld

binary: entry.o main.o linker.lds
	$(LD) entry.o main.o -o $@ --script=linker.lds

linker.lds: linker.lds.S
	$(CPP) $< -P -o $@
