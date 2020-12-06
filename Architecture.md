# Architecture
The overall architecture of NPL is quite simple.

**NPL stores its programs and data in 8-bit format.**

Each command and parameter takes up **exactly 1 byte** in binary form.

In order to futher simplify the algorhitms responsible for compilation, every line of code is 3 bytes as compiled binary.

If a command expects less than 2 parameters, the compiler will add the remaining parameter(s) as 0, e.g. `pull 0` will become `pull 0 0` after compilation.

**A command cannot use more than 2 parameters.**

## Registers and memory
NPL's Virtual Machine (NVM) offers 1 working register conveniently called 'A'. The instruction pointer is not accessible through regular program and cannot be read from.

The commands controlling the registers are listed in [Syntax](Syntax.md).

Besides the registers, NVM also allows for RAM. There is 1 KB (1024B) of RAM in the machine. Only the first 256B are addressable.

**The program is stored in the upper 768B of RAM.** With each command taking up 3B, the maximum amount of code saved in RAM is 256 lines.

## Save files, memory dumps
First, see [Compilation process details](Compile.md#details).

The .bin files (output from compiler) are just memory dumps. This allows the developer to include a starting value for the data inside the first 256B of RAM.

This feature is commonly used for storing the alphabet, as the `chr` command doesn't support direct [ASCII](https://en.wikipedia.org/wiki/Ascii) codes (See [Syntax](Syntax.md))

Binary dumps are 1KB in size, as they represent the whole RAM.
