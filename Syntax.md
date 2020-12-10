# Syntax
The most detailed syntax guide you'll find on the web.

## Commands
List of commands with short descriptions:

- [NOP](#nop) - does nothing
- [PUSH](#push) - copies value from A to memory
- [PULL](#pull) - "pulls" data from RAM to A
- [ADD](#add) - adds value from memory to A
- [SUB](#sub) - subtracts value from memory from A
- [MOD](#mod) - performs modulo division; divides A by value from RAM
- [MUL](#mul) - multiplies A by a value from RAM
- [DIV](#div) - performs integer division between A and RAM
- [XOR](#xor) - XORs A with the value from memory
- [AND](#and) - ANDs together A and RAM
- [OR](#or) - performs bitwise OR on A and RAM
- [JMP](#jmp) - jumps to a specified address
- [JC](#jc) - jump if carry
- [JZ](#jz) - jump if zero
- [JO](#jo) - jump if odd
- [JNC](#jnc) - jump if not carry
- [JNZ](#jnz) - jump if nonzero
- [JE](#je) - jump if even
- [IN](#in) - get input from user
- [SET](#set) - set a value in memory
- [DROP](#drop) - set a memory cell to 0
- [CHR](#chr) - display a character
- [OUT](#out) - display contents of a memory cell
- [SHR](#shr) - shift A right
- [SHL](#shl) - shift A left
- [AIN](#ain) - get ascii input from user
- [MOV](#mov) - move a value between cells
- [CPY](#cpy) - copy a value between cells
- [DEAL](#deal) - sets the deal statement

## Concepts
This section explains concepts used later in the document.

### A register
The A register is a piece of memory outside of RAM. It can be used to perform bitwise/arythmetic operations.
The developer can move values between it and the RAM by utilizing register commands.

See: [Architecture](Architecture.md).

### Pointer
A pointer is specified by putting an asterisk (*) in front of a command parameter. Pointers are crucial in systems, in which the user specifies an address of memory to be read from or written to.

**Disclaimer: Pointers, combined with no validation of user input can lead to arbitrary NPL code execution. Make sure to properly isolate the user-accessible space from program space. If not necessary, don't perform a jump to a pointer (Especially if it originated from an untrusted source).**

Pointers can be utilized if the programs needs to decide where to jump based on previous decisions.

#### Example
Here I'll show what happens with and without a pointer:

We have a simple scenario.

```
pull 0xAB
push 0xCD
```
Without the pointers, it's quite simple. The parser reads the contents of memory at address 0xAB and saves it to the A register. Then, it saves that into memory at address 0xCD.

Now, let's see it again with pointers:

```
pull 0xAB
push *0xCD
```
Here we specify that 0xCD is a pointer. Parser still reads value at address 0xAB into A. It sees 0xCD as a pointer. It grabs the value at address 0xCD. Let's say it's 0xEF. The program then goes to address 0xEF and saves it there.

**Parser**

Resolves address => Sees a pointer => Uses the **value** at that place as the new address

### Instruction Pointer
The Instruction Pointer (IP) is an 8-bit register storing the address of currently executed instruction. It can be altered using the jump/branch commands. In NVM, it cannot be read from.

## Command details
Detailed explanation for every command.

The examples are in the following format:

`code in NPL` => `compiled form` => `pseudocode explanation`

### Register commands
Commands controlling the registers.

#### SHR
Shifts the A register right. The number of places is taken directly from the parameter. Memory is not read.

Example: `shr 0x01` => `17 01 00` => `A = A >> 0x01`

#### SHL
Shifts the A register left. The number of places is taken directly from the parameter. Memory is not read.

Example: `shl 0x02` => `18 02 00` => `A = A << 0x02`

#### PUSH
Pushes a value into the RAM from the register.

Example: `push 0x46` => `01 46 00` => `RAM[0x46] = A`

#### PULL
Pulls a value from RAM into the A register.

Example: `pull 0x6c` => `02 6c 00` => `A = RAM[0x6c]`

#### ADD
Pulls a value from RAM and adds it to the current A value. It keeps the value in 8 bits.

Example: `add 0x61` => `03 61 00` => `A = (A + RAM[0x61]) & 0xFF`

#### SUB
Pulls a value from RAM, subtracts from A. Just like add, it ands it with 0xFF to prevent values over 8 bits.

Example: `add 0x67` => `04 67 00` => `A = (A - RAM[0x61]) & 0xFF`

#### MOD
Pulls a value from memory, sets A to the reminder of: A / V (A divided by the value)

Example: `mod 0x3a` => `05 3a 00` => `A = A % RAM[3a]`

#### MUL
Pulls a value from RAM and multiplies A by it.

Example: `mul 0x20` => `06 20 00` => `A = (A * RAM[0x20]) & 0xFF`

#### DIV
Pulls a value from RAM, performs integer division between it and A.
**A remains unchanged, if the RAM value is equal to 0!**

Example: `div 0x43` => `07 43 00` => `A = floor(A / RAM[0x43])`

#### XOR
Pulls a value from memory, performs bitwise XOR with A.

Example `xor 0x54` => `08 54 00` => `A = A ^ RAM[0x54]`

#### AND
Pulls the memory value, ANDs it with A.

Example: `and 0x46` => `09 46 00` => `A = A & RAM[0x46]`

#### OR
Pulls a RAM value, performs bitwise OR.

Example: `or 0x7b` => `0a 7b 00` => `A = A | RAM[0x7b]`

### Jump/branch commands
Commands altering the IP.

#### JMP
Reads the value from RAM, updates the IP. In actual source code, the value is multiplied by 3 and offset by 256.

Example: `jmp 0x77` => `0b 77 00` => `IP = RAM[0x77] * 3 + 256`

#### JC
Performs a branch (jump, `jmp`) **if the carry flag is set to true** (See: [Flags](Architecture.md#flags-register))

Example: `jc 0x33` => `0c 33 00` => `if CARRY_FLAG then IP = RAM[0x33] * 3 + 256`

#### JZ
Branches **if the zero flag is active (set to true)** (See: [Flags](Architecture.md#flags-register))

Example: `jz 0x6c` => `0d 6c 00` => `if ZERO_FLAG then IP = RAM[0x6c] * 3 + 256`

#### JO
Branches **if the odd flag is active** (See: [Flags](Architecture.md#flags-register))

Example: `jo 0x6c` => `0e 6c 00` => `if ODD_FLAG then IP = RAM[0x6c] * 3 + 256`

#### JNC
Branches **if the carry flag is inactive** (See: [Flags](Architecture.md#flags-register))

Example: `jnc 0x5f` => `0f 5f 00` => `if not CARRY_FLAG then IP = RAM[0x5f] * 3 + 256`

#### JNZ
Branches **unless the zero flag is active** (See: [Flags](Architecture.md#flags-register))

Example: `jnz 0x68` => `10 68 00` => `if not ZERO_FLAG then IP = RAM[0x68] * 3 + 256`

#### JE
Branches **if the odd flag is set to false** (See: [Flags](Architecture.md#flags-register))

Example: `je 0x31` => `11 31 00` => `if not ODD_FLAG then IP = RAM[0x31] * 3 + 256`

### Interface commands
I/O commands.

#### IN
Takes a decimal 8-bit integer from the user from STDIN. It saves the result into RAM. If the value is bigger than 255, it gets cut.

Example: `in 0x64` => `12 64 00` => `RAM[0x64] = ask_user().to_integer() & 0xFF`

#### CHR
Displays a value from RAM as an ASCII character to STDOUT.

Example: `chr 0x64` => `15 64 00` => `print(RAM[0x64].get_ascii_char())`

#### OUT
Displays the hexadecimal contents of a RAM cell to STDOUT.

Example: `out 0x33` => `16 33 00` => `print(RAM[0x33].get_hex_string())`

#### AIN
Takes an ASCII character from the STDIN and saves it into RAM as an integer.

Example: `ain 0x6e` => `19 6e 00` => `RAM[0x6e] = ask_user().first_char().get_ascii_index()`

### Memory operations
Commands altering the memory without touching the A register.

#### SET
Takes **2 parameters**: The address and value. Sets the RAM value to the specified one. Pointers aren't supported.

Example: `set 0x5f 0x68` => `13 5f 68` => `RAM[0x5f] = 0x68`

#### DROP
Empties a RAM cell.

Example: `drop 0x75` => `14 75 00` => `RAM[0x75] = 0`

#### MOV
Moves a value between RAM cells. Sets the source cell to 0. Pointers ain't supported.

Example: `mov 0x68 0x21` => `1a 68 21` => `RAM[0x21] = RAM[0x68]; RAM[0x68] = 0`

#### CPY
Copies a value between cells. No luck with pointers!

Example: `cpy 0x3f 0x7d` => `1b 3f 7d` => `RAM[0x7d] = RAM[0x3f]`

### Miscellaneous
Other commands.

#### NOP
Does nothing.

Example: `nop` => `00 00 00` => `(nothing)`

#### DEAL
Sets up a deal statement.

The deal statement **is not being compiled**. It's a special case, which tells the compiler, how to deal with values over 255 in the code.

Two values are available:

`deal error` (default) - stops compilation and throws an error

`deal cut` - cuts the value, leaving the last 8 bits

***I recommend putting the deal statement at the beginning of your file, so it applies to the whole file.***
