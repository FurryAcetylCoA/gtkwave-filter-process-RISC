## Gtkwave filter process for RISC-V


### Before:
![before](img/before.png)

### After:
![after](img/after.png)

### Support targets:
* RISC-V 32/64 with M/A/C/F/D

### Usage 
1) Highlight the signals you want filtered
2) Edit->Data Format->Translate Filter File->Enable and Select
3) Add Filter executable to List
4) **Click on filter filename**
5) Select filter filename from list
6) click OK

### Build dependency
* LLVM >= 11 (tested on 16)
* Clang++
* Mold (optional)

Pre-built binary can be found in release (built with LLVM-16)