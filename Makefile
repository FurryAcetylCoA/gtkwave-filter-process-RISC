CXX = clang++

CXXFLAGS += $(shell llvm-config --cxxflags) -O3 -flto
# CXXFLAGS += -DDEBUG_DUMP_INST
LIBS += $(shell llvm-config --libs)
LDFLAGS += $(shell llvm-config --ldflags)
LDFLAGS += $(shell if command -v mold --version >/dev/null 2>&1; then echo "-fuse-ld=mold"; fi)
LDFLAGS += -Wl,-rpath='$$ORIGIN'
SRCS = $(wildcard src/*.cpp)
BUILDDIR = bin
FLAGS = $(CXXFLAGS) $(LDFLAGS) $(LIBS)

all: $(BUILDDIR)/gtkwave-filter-rv64 $(BUILDDIR)/gtkwave-filter-rv32 $(BUILDDIR)/gtkwave-filter-la32 $(BUILDDIR)/gtkwave-filter-mips32 $(BUILDDIR)/gtkwave-filter-mipsel32

$(BUILDDIR)/gtkwave-filter-rv32: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DTARGET="riscv32"

$(BUILDDIR)/gtkwave-filter-rv64: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DTARGET="riscv64"

$(BUILDDIR)/gtkwave-filter-la32: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DTARGET="loongarch32"

$(BUILDDIR)/gtkwave-filter-mips32: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DTARGET="mips"

$(BUILDDIR)/gtkwave-filter-mipsel32: $(SRCS) | $(BUILDDIR)
	@echo + CXX "->" $@
	$(CXX) $^ $(FLAGS) -o $@ -DTARGET="mipsel"


$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

.PHONY: clean all
