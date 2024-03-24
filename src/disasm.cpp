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

#include <capstone/capstone.h>
#include <string>
#include <iostream>
#include <sstream>

static csh handle;

void init_disasm(std::string triple) {
    cs_open(CS_ARCH_RISCV, CS_MODE_RISCV32, &handle);
}

std::string disassemble(uint64_t hx) {
    uint8_t *code = reinterpret_cast<uint8_t *>(&hx);
    cs_insn *insn;
    std::ostringstream oss;
    int count = cs_disasm(handle, code, sizeof(uint32_t), 0, 1, &insn);
    if(!count){
        std::cout<<"Failed"<<std::endl;
    }

    oss<<insn->mnemonic<<" "<<insn->op_str<<std::endl;
    return oss.str();
}
