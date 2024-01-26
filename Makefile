LDFLAGS += -fuse-ld=mold -lLLVM-16
SRCS = $(wildcard src/*.cpp)
BUILDDIR = bin

all: $(BUILDDIR)/gtkwave-filter-rv64 $(BUILDDIR)/gtkwave-filter-rv32

$(BUILDDIR)/gtkwave-filter-rv32: $(SRCS) | $(BUILDDIR)
	clang++ $(LDFLAGS) $^ -o $@ -DTARGET="riscv32"

$(BUILDDIR)/gtkwave-filter-rv64: $(SRCS) | $(BUILDDIR)
	clang++ $(LDFLAGS) $^ -o $@ -DTARGET="riscv64"	

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

.PHONY: clean all
