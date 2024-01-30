/***************************************************************************************
 * Copyright (c) 2024 Yanglin Xun
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

#include <cstdint>
#include <iostream>
#include <sstream>

#define _S(x) #x
#define S(x) _S(x)

#ifndef TARGET
#define TARGET riscv32
#endif

std::string disassemble(uint64_t);
void init_disasm(std::string triple);

int main() {
    std::string buf, ret_string;
    init_disasm(S(TARGET));
    uint64_t hx;
    while (std::cin >> buf) {
        std::istringstream iss(buf);
        iss >> std::hex >> hx;
        ret_string = disassemble(hx);
        std::cout << ret_string << std::endl;
    }
    return 0;
}
