CXXFLAGS += $(shell llvm-config --cxxflags) -O2
LIBS += $(shell llvm-config --libs)
LDFLAGS += $(shell llvm-config --ldflags)
LDFLAGS += $(shell if command -v mold --version >/dev/null 2>&1; then echo "-fuse-ld=mold"; fi)
SRCS = $(wildcard src/*.cpp)
FLAGS = $(CXXFLAGS) $(LDFLAGS) $(LIBS)
BUILDDIR = bin
CC = clang++

ifeq ($(CC), clang++)
	LDFLAGS += -flto=thin 
endif

all: $(BUILDDIR)/gtkwave-filter-rv64 $(BUILDDIR)/gtkwave-filter-rv32

$(BUILDDIR)/gtkwave-filter-rv32: $(SRCS) | $(BUILDDIR)
	@echo + CC "->" filter-32
	@$(CC) $^ $(FLAGS) -o $@ -DTARGET="riscv32"

$(BUILDDIR)/gtkwave-filter-rv64: $(SRCS) | $(BUILDDIR)
	@echo + CC "->" filter-64
	@$(CC) $^ $(FLAGS) -o $@ -DTARGET="riscv64"	

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

.PHONY: clean all
