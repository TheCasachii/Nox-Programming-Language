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

(to be continued 12.12)
