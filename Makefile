CXX = clang++

CXXFLAGS += -O3 -flto -I/home/coa/tmp/capstone-next/include/
LIBS += -Wl,-Bstatic -lm -lcapstone -Wl,-Bdynamic
LDFLAGS += $(shell llvm-config --ldflags) -L.
LDFLAGS += $(shell if command -v mold --version >/dev/null 2>&1; then echo "-fuse-ld=mold"; fi)
SRCS = $(wildcard src/*.cpp)
BUILDDIR = bin
FLAGS = $(CXXFLAGS) $(LDFLAGS) $(LIBS)

all: $(BUILDDIR)/gtkwave-filter-rv64 $(BUILDDIR)/gtkwave-filter-rv32 $(BUILDDIR)/gtkwave-filter-la32

$(BUILDDIR)/gtkwave-filter-rv32: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DTARGET="riscv32"

$(BUILDDIR)/gtkwave-filter-rv64: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DTARGET="riscv64"

$(BUILDDIR)/gtkwave-filter-la32: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DTARGET="loongarch32"


$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

.PHONY: clean all
