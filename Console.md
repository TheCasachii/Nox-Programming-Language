# Interactive Console
The developer's best friend! (and the hacker's best puppet)

## Overview
Here's a brief overview of the IC features.

### Memory modification
The IC can modify a program loaded into memory. You can access the whole 1KB of memory. You can also read data from memory cells.

### Signature repair
If you modify a program, it will be rejected and won't run. You can fix the signature of a program using the IC.

### Compilation
Using IC commands, you can compile source code to binary form. (See: [Compilation](Compile.md))

### Program execution
With the help of IC, you can run programs loaded into memory.

### Memory dumping
Using IC, you can dump the RAM after modifying the code. This way, you can save it for later or share your program.

### Loading memory dumps
Because of the .bin files produced by the compiler being just memory dumps (See: [Save files, memory dumps](Architecture.md#save-files-memory-dumps)), dumps produced by the IC can be loaded into memory and executed.

### Macros
The IC also supports macros in form of .mac files. These files contain list of IC commands to make common tasks (like injecting a character set) faster and easier.

## Syntax
IC commands **must** be lowercase. Otherwise, the IC parser might not recognize them properly. Commands are 3-4 characters long strings followed by 1-2 parameters. Parameters are split by a space.

`set 0x12 0x34` - set a value in RAM at address 0x12 to 0x34.

## Details
Explanation and example for each command.

### Set
The set command writes a value to the RAM.

`set <address> <value>`

Example: `set 0x12 0x34`

### Get
The command called "get" gets a value from RAM and displays it on screen.

`get <address>`

Example: `get 0x56`

### Mac
The mac command sadly doesn't allow you to run MacOS inside of NPL. Its sole purpose is to run macros.

**Warning: Running `mac` command from a mac will throw an error! This is intentional and implemented to prevent from running recursive macros.**

`mac <filename>`

Example: `mac my_mac.mac`

### Load
The load command loads a memory dump (or compiled binary) and loads it into memory.
There are a few restrictions:

- The file has to exist (obviously)
- The file size has to be **exactly** 1024B
- The signature **must be valid**

What if I need to fix the signature of a program? If I can't load it, I can't fix it!

In that case, you can:
- Fix the signature manually using a hex editor (that's boring)
- Reverse-engineer the way signature fixes work (Hint: It's in the `NoxLang.parse_ic` function) and write a script to apply the same process (if you do that, I'm proud :D )
- Just bypass the security and use my automated tools (the lame option)

### Compile
The compile command:
1. Opens the input file
1. Compiles it
1. Saves output to memory
1. Dumps memory into the output file

`compile <input> <output>`

Example: `compile my_app.npl my_app.bin`

### Exit
The exit commands ends your NPLIC session.

`exit`

### Run
The run command executes code currently stored in RAM. It checks the signature.

`run`

### Sig
Sig utility allows you to modify the code signature.

`sig <action>`

#### Action
The action parameter should be one of the following options:
- update
- set
- get

#### Sig update
The command above will calculate the signature of RAM and automatically update it to be correct.

`sig update`

#### Sig set
This allows the developer to set an arbitrary signature for their code. After typing in `sig set` you'll be asked for 

`sig set`

#### Sig get
The `sig get` command prints the currently used signature.

`sig get`

### Dump
The dump command dumps the contents of RAM into a file.

`dump <file>`

Example: `dump my_dump.bin`

The memory dumps are in the same form as compiled programs.
