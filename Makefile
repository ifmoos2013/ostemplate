export AS = yasm
export ASFLAGS = -f elf32

export LD = ld
export LDFLAGS = -m elf_i386

export AR = ar
export ARFLAGS = rcs

QEMU = qemu-system-x86_64
QEMUFLAGS = -m 1024

KERNEL = mylinux
SUBMODULES = boot kernel

OBJ = $(foreach DIR, $(SUBMODULES), $(DIR)/$(DIR).a)

all: $(KERNEL)

run: $(KERNEL)
	$(QEMU) $(QEMUFLAGS) -kernel $(KERNEL)

$(KERNEL): $(OBJ)
	$(LD) $(LDFLAGS) $^ -o $@

%.a: FORCE
	$(MAKE) -s -C $(shell dirname $@)

FORCE:

clean:
	for dir in "$(SUBMODULES)" ; do $(MAKE) clean -s -C kernel ; done
	rm -f $(KERNEL)

.PHONY: all clean
