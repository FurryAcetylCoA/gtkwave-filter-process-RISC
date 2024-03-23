## Gtkwave filter process for RISC


### Before:
![before](img/before.png)

### After:
![after](img/after.png)

### Support targets:
* RISC-V 32/64 with M/A/F/D
* LoongArch32 reduce

### Usage 
1) Highlight the signals you want filtered
2) Edit->Data Format->Translate Filter Process->Enable and Select
3) Click Add Proc Filter to List
4) Open file
5) **Select filter filename from list** $\color{red} {❗IMPORTANT❗} $
6) click OK

> **_NOTE:_**  You can use *File ->Write save file* after applying this filter. This way, it will be applied automatically next time.


### Build dependency
* LLVM >= 11 (tested on 16)
* Clang++
* Mold (optional)


Pre-built binary can be found in release (built with LLVM-16)
