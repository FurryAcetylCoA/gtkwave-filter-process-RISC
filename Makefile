CXX = g++

CXXFLAGS += -O3 -I/home/coa/tmp/capstone-next/include/
LIBS += -Wl,-Bstatic -lm -lcapstone -Wl,-Bdynamic
# LDFLAGS += $(shell llvm-config --ldflags) -L.
LDFLAGS += -L.
# LDFLAGS += $(shell if command -v mold --version >/dev/null 2>&1; then echo "-fuse-ld=mold"; fi)
SRCS = $(wildcard src/*.cpp)
BUILDDIR = bin
FLAGS = $(CXXFLAGS) $(LDFLAGS) $(LIBS)

all: $(BUILDDIR)/gtkwave-filter-rv64 $(BUILDDIR)/gtkwave-filter-rv32 $(BUILDDIR)/gtkwave-filter-la32

$(BUILDDIR)/gtkwave-filter-rv32: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DCSARCH=CS_ARCH_RISCV -DCSMODE=CS_MODE_RISCV32

$(BUILDDIR)/gtkwave-filter-rv64: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DCSARCH=CS_ARCH_RISCV -DCSMODE=CS_MODE_RISCV64

$(BUILDDIR)/gtkwave-filter-la32: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DCSARCH=CS_ARCH_LOONGARCH -DCSMODE=CS_MODE_LOONGARCH32


$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

.PHONY: clean all
