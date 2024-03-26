/***************************************************************************************
 * Copyright (c) 2024 Yanglin Xun
 * Copyright (c) 2014-2022 Zihao Yu, Nanjing University
 *
 * GTKWAVE-FILTER-RV is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan
 *PSL v2. You may obtain a copy of Mulan PSL v2 at:
 *          http://license.coscl.org.cn/MulanPSL2
 *
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY
 *KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 *NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 *
 * See the Mulan PSL v2 for more details.
 ***************************************************************************************/

#if defined(__GNUC__) && !defined(__clang__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
#endif

#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDisassembler/MCDisassembler.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/TargetSelect.h"

#if defined(__GNUC__) && !defined(__clang__)
#pragma GCC diagnostic pop
#endif

#if LLVM_VERSION_MAJOR < 16
#error Please use LLVM with major version >= 16
#endif


using namespace llvm;

static llvm::MCDisassembler *gDisassembler = nullptr;
static llvm::MCSubtargetInfo *gSTI = nullptr;
static llvm::MCInstPrinter *gIP = nullptr;

void init_disasm(std::string triple) {
  llvm::InitializeAllTargetInfos();
  llvm::InitializeAllTargetMCs();
  llvm::InitializeAllAsmParsers();
  llvm::InitializeAllDisassemblers();

    std::string errstr;

    llvm::MCInstrInfo *gMII = nullptr;
    llvm::MCRegisterInfo *gMRI = nullptr;
    auto target = llvm::TargetRegistry::lookupTarget(triple, errstr);
    if (!target) {
        llvm::errs() << "Can't find target for " << triple << ": " << errstr
                     << "\n";
        assert(0);
    }

    MCTargetOptions MCOptions;
    gSTI = target->createMCSubtargetInfo(triple, "", "");
    std::string isa = target->getName();
    if (isa == "riscv32" || isa == "riscv64") {
    	gSTI->ApplyFeatureFlag("+m");
    	gSTI->ApplyFeatureFlag("+a");
    	// gSTI->ApplyFeatureFlag("+c");
    	gSTI->ApplyFeatureFlag("+f");
        gSTI->ApplyFeatureFlag("+d");
    }
    gMII = target->createMCInstrInfo();
    gMRI = target->createMCRegInfo(triple);
    auto AsmInfo = target->createMCAsmInfo(*gMRI, triple, MCOptions);
    auto llvmTripleTwine = Twine(triple);
    auto llvmtriple = llvm::Triple(llvmTripleTwine);
    auto Ctx = new llvm::MCContext(llvmtriple, AsmInfo, gMRI, nullptr);
    gDisassembler = target->createMCDisassembler(*gSTI, *Ctx);
    gIP = target->createMCInstPrinter(llvm::Triple(triple),
                                      AsmInfo->getAssemblerDialect(), *AsmInfo,
                                      *gMII, *gMRI);
    gIP->setPrintImmHex(true);
    if (isa == "riscv32" || isa == "riscv64")
        gIP->applyTargetSpecificCLOption("no-aliases");
}

std::string disassemble(uint64_t hx) {
    uint8_t *code = reinterpret_cast<uint8_t *>(&hx);
    MCInst inst;
    llvm::ArrayRef<uint8_t> arr(code, 4);
    uint64_t dummy_size = 0, addr = 0;
    std::string s;
    raw_string_ostream os(s);
    if(gDisassembler->getInstruction(inst, dummy_size, arr, addr, llvm::nulls()) != MCDisassembler::Success){
        os << "invalid inst:" << llvm::format_hex_no_prefix(hx,8);
        return s;
    }

#ifdef DEBUG_DUMP_INST
    // Output current instruction in both hex and binary to stderror
    llvm::APInt hex_value(64, hx);
    llvm::errs() << "cursor inst: (HEX)" << llvm::format_hex_no_prefix(hx,8) << " ";
    llvm::errs() << "(BIN)" << toString(hex_value, 2, false) <<"\n";
#endif // DEBUG_DUMP_INST

    gIP->printInst(&inst, addr, "", *gSTI, os);

    // Assume result format "\tOpName\tOperands"
    size_t tabPosition = s.find("\t");
    while (tabPosition != std::string::npos) {
        s.replace(tabPosition, 1, " ");
        tabPosition = s.find("\t", tabPosition + 1);
    }
    return s.substr(1);
}
