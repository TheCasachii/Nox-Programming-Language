# Alphabet Injection
The complete guide.

## The basics
Because the `chr` command by design **doesn't support direct ASCII values**, programmers have to inject correct ASCII values into the RAM. Alphabet injection is the process of inserting these values into the compiled binary

This can be done in 3 ways:
1. SET statements during runtime (simplest, takes up space)
1. SET statements during compilation through NPLIC (has to be repeated after every compilation)
1. SET statements in a macro (best solution)

Our goal is to get the alphabet into the first 256 bytes of memory.

Imagine that you need to display the word "Hello".

In that case, we'd need to store 4 letters in RAM.
Let's store them at addresses 0-3.

RAM:

0 - H

1 - e

2 - l

3 - o

Program:
```
chr 0
chr 1
chr 2
chr 2
chr 3
```

As you can see, the parameter of chr is the address of character to be displayed. We don't need to store duplicate letters, as addresses can be reused.

## How-To
How to inject an alphabet.

### Method 1
Set statements during runtime.

Step-by-step:
1. For each unique letter of the alphabet, put at the beginning of your program: `set <char_address> <ascii_code>`

This method is very inefficient. Letters are loaded into memory at boot time. Every character takes up 4 bytes when set up. The other two methods allow you to store them more efficiently.

### Method 2
Set statements during compilation through NPLIC.

Step-by-step:
1. Launch the NPL Interactive Console: `ruby nox_exec.rb -i`
1. Compile the file without the alphabet: `compile <source> <destination>` OR load compiled binary: `load <file>`
1. For each unique letter of the alphabet, type in: `set <char_address> <ascii_code>`
1. Sign your code: `sig update`
1. Save your file: `dump <destination>`

This method is very efficient in terms of storage but requires repeating of the whole process after changes to the source code. Characters take up 1 byte of space in the compiled binary.

### Method 3
Set statements in a macro

Step-by-step:
1. Create a new file with a .mac extension. This is a NPL macro.
1. Open the file in a text editor
1. For each unique letter of the alphabet, type in: `set <char_address> <ascii_code>`
1. Launch NPLIC
1. Compile/load the file
1. Type in: `mac <your_.mac_file>`
1. Sign the code: `sig update`
1. Save the file: `dump <destination>`

It may seem like this method is more involved than the previous ones. In case of rebuilding your old project however, you only need to repeat steps 4-8. In terms of space, it's identical to the method 2. It's the best method to inject the alphabet.

## Fix broken characters
If you forgot to put some characters in RAM, you can add them later.

Here, the macro method works most reliably, especially without access to the source code.

Appending new characters is more involved than injecting the alphabet.

Here I'll show how to append them at the end. The process is similar for other situations.

First, you need to check, where the alphabet starts and ends. To do this:
1. Open [NPLIC](Console.md)
1. Load your binary into RAM
1. Type in: `get <x>`. Start at x = 0 and increment with each command. **Important: Make sure you note the first AND last value of x where the response was greater than 0**
1. The **first** value of x with response > 0 is the start of the alphabet. If you're fixing characters at the start, this is the place to look at. We are fixing them at the end so we're interested in the latter one.

After that, follow the 'Method 3' guide above. **Note: You want to use numbers starting with X+1 as your char_address!**

### Example:
We wanted to print the word 'Hello' but we forgot about the characters 'l' and 'o'.

Here's the script printing the word:

```
chr 0
chr 1
chr 2
chr 2
chr 3
hlt 0
```

If you don't know what these commands mean, refer to [Syntax](Syntax.md).

We've injected 72 (H) into memory cell 0 and 101 (e) into cell 1.

We open NPLIC (the example is done on Linux):

`$ ruby ./nox_exec.rb -i`

The response is:

```
Copyright (C) 2020 Casachii

Licensed under GNU General Public License 3.0

Nox Interactive Console

Version 1.0

~> 
```

We start by analizing the RAM.

```
~> load print_the_hello.bin
Loaded file into memory.
~> get 0
Value at 0 is 72.
~> get 1
Value at 1 is 101.
~> get 2
Value at 2 is 0.
```

We can see that the starting address is 0 and the ending address is 1.

We follow the 'Method 3' guide:

(in a new Terminal window)

```
$ touch hello_patch.mac
$ nano hello_patch.mac
```

We write:

```
set 2 108
set 3 111
```

Set means setting an address. We start at address X+1. X is the ending address (1) so 1 + 1 is 2.
We set it to 108, which is the ASCII representation of 'l'.

We do the same for 'o', incrementing the address and changing the value to 111.

After that, we exit GNU Nano and inject our patch:

```
$ ruby ./nox_exec.rb -i

Copyright (C) 2020 Casachii

Licensed under GNU General Public License 3.0

Nox Interactive Console

Version 1.0

~> load print_the_hello.bin
Loaded file into memory.
~> mac hello_patch.mac
Written 108 to cell 2.
Written 111 to cell 3.
~> sig update
Updated the signature to: 152564
~> dump print_the_hello.bin
Memory dump saved to file.
~> run
HelloProgram exit with code: 0x00
```

Let's explain:
- load pri..lo.bin - Loads the binary file into memory
- mac hel..ch.mac - Applies the patch
- sig update - Updates the signature (you won't be able to run/load your program if you don't do that)
- dump pri..lo.bin - Saves the modified program to a file
- run - Executes the code
