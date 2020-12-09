# Syntax
The most detailed syntax guide you'll find on the web.

## Commands
List of commands with short descriptions:

- NOP - does nothing
- PUSH - copies value from A to memory
- PULL - "pulls" data from RAM to A
- ADD - adds value from memory to A
- SUB - subtracts value from memory from A
- MOD - performs modulo division; divides A by value from RAM
- MUL - multiplies A by a value from RAM
- DIV - performs integer division between A and RAM
- XOR - XORs A with the value from memory
- AND - ANDs together A and RAM
- OR - performs bitwise OR on A and RAM
- JMP - jumps to a specified address
- JC - jump if carry
- JZ - jump if zero
- JO - jump if odd
- JNC - jump if not carry
- JNZ - jump if nonzero
- JE - jump if even
- IN - get input from user
- SET - set a value in memory
- DROP - set a memory cell to 0
- CHR - display a character
- OUT - display contents of a memory cell
- SHR - shift A right
- SHL - shift A left
- AIN - get ascii input from user
- MOV - move a value between cells
- CPY - copy a value between cells
- DEAL - sets the deal statement

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
Here we specify that 0xCD is a pointer. Parser still reads 0xAB into A. It sees 0xCD as a pointer. It grabs the value at address 0xCD. Let's say it's 0xEF. The program then goes to address 0xEF and saves it there.

**Parser**

Resolves address => Sees a pointer => Uses the **value** at that place as the new address

## Command details
Detailed explanation for every command.

### NOP
The NOP command is not taking any parameters. It's not performing any operations, either.

Hex: 0x00

### PUSH

Syntax: `push <addr>`

The parser gets the current value from the A register and saves it into the RAM at address <addr>.

Params:
<addr> - **required**, the address to write to.

Hex: 0x01

### PULL

Syntax: `pull <addr>`

NPL parser gets data from RAM at address <addr> and puts it into the A register. The data is copied.

Params:

<addr> - **required**, the address to pull data from.

Hex: 0x02
