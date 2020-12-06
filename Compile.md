# Compilation
The compilation process and instructions.

After reading this, you should be able to:
- Compile your own NPL programs (See [Syntax](Syntax.md) for NPL syntax)
- Understand the basic principles of the compilation process
- Understand compiler errors, debug your code

## How to compile
You can take one of two available paths:

1) Compilation through command line arguments:
    - Execute in CMD/Terminal: `ruby ./nox_exec.rb -c path/to/source.npl desired/output/file.bin`
    - This method is faster
    - Doesn't allow for instant code modification afterwards
1) Compilation through [Interactive Console](Console.md):
    - Execute in CMD/Terminal: `ruby ./nox_exec.rb -i`
    - Type in: `compile path/to/source.npl desired/output/file.bin`
    - Requires more typing
    - Easy code modification and data injection - the compiled code is loaded into memory and can be altered with `set` and read from by `get` (Refer to [Memory modification](Console.md#set))
    - You can run the compiled code immediately by typing in `run`

## Details
The technical explanation of the compilation process

**Compilation of NPL code is based on a table of translations**

Each command in NPL is combined with a binary opcode like this:

```
plaintext_commands = %w[nop push pull...]
...
compiled << (plaintext.index command)
```

The commands are listed in [Syntax](Syntax.md).

### Under the hood
The compilation process is more involved than just checking values with a table and placing them in the 'compiled' array.

Here's a step-by-step explanation of the compilation process:

1) The compiler goes through the whole file, checking for:
    - Empty lines (after `line.chomp`)
    - Typos
    - [Deal statements](Syntax.md#deal)
    - Invalid parameters
    - Range errors
    - Signature issues
1) After the process of validation and removal of empty lines the compiler either exits with an error code or:
    - Sets up the 'compiled' array as 256 zeros (first 256B of RAM)
    - Goes through the file line by line, indexing commands + parameters and injecting into 'compiled' array
    - Extends the length of 'compiled' to 1021 with trailing zeros
1) Compiler goes through the entire array, calculates the 3B checksum:
    - The first byte of checksum is the last 8 bits from the sum of all bytes in 'compiled': `3F 23 A0` => (3F + 23 + A0) & FF = 02
    - The second byte of checksum is the result of XOR of **all bytes in 'compiled'**: `3F 23 A0` => (3F ^ 23 ^ A0) = BC
    - The final byte of checksum is: ((FirstByte + SecondByte) & F) ^^ 2 (^^ means exponent): `02 BC` => ((02 + BC) & F) ^^ 2 = C4
In this scenario, the checksum was `02 BC C4`. It gets appended to the end of 'compiled'.
    
## Understanding compiler errors
During compilation of your projects, you may stumble upon a couple of different compiler errors.

This part of the Compilation Guide explains in detail what they mean and lists common solutions.

### ERROR: Opcode Out Of Range
This error code appears when a command is given which is not recognized by the system.

It often appears when a typo was made. Make sure to check the spelling of your code.

**Solution: Check the spelling. The correct spelling of each command is specified in [Syntax](Syntax.md).**

### ERROR: Parameter Out Of Range
This error is shown when one of the parameters given to a command doesn't fit in 8 bits.

It can appear when the given parameter is above 255 (0xFF).

**Solution: You can specify, how the compiler deals with this error by adding a [deal statement](Syntax.md#deal) at the beginning of your file.**

### ERROR: Signature Overriden
This error will appear if program length is above 255 lines. The 256th line is reserved for the code signature and cannot be overriden. It's also not addressable due to the 8 bit limitation.

It appears when your code is too long.

**Solution: There's no easy way to solve this, you have to limit yourself to 255 lines of code.**

### ERROR: Parameter Not Found
It appears when a parameter is missing, e.g. no parameters are given to a command that expects at least one.

You'll see this error when incorrect number of parameters is given.

**Solution: Refer to [Syntax](Syntax.md) in order to check the number of arguments required by each command.**

### ERROR: Invalid DEAL Statement
This error will show up when you type in a wrong DEAL statement value.

It'll be shown when you give invalid parameters to the `deal` command.

**Solution: Refer to [Deal statement](Syntax.md#deal) for available parameter values.**

### ERROR: Internal Error
This can happen when nox_lang.rb was modified in a specific way, allowing for illegal values to be put in, e.g. [deal statement](Syntax.md#deal) value was not recognized.

This can occur after you've modified the source code or downloaded it from an untrusted source.

**Solution: Rollback any changes made to code or reinstall NPL. You can get the installation steps in [README](README.md).**
