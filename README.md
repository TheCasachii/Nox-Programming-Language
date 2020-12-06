# Nox Programming Language
The repository for the Nox language. Created for CTF challenge.

This README file will teach you how to install and execute Nox Parser/Compiler.

Here's a list of helpful documentations:
- [Architecture](Architecture.md)
- [Compilation](Compile.md)
- [Interactive console](Console.md)
- [Runtime](Run.md)
- [Syntax](Syntax.md)

## Installation
In order to install Nox, go to the desired installation directory and clone the repository using git clone:

`git clone https://github.com/TheCasachii/Nox-Programming-Language.git`

**Alternatively, you can download and unpack the [zip archive](https://github.com/TheCasachii/Nox-Programming-Language/archive/main.zip)**

Then go to the repo folder:

`cd Nox-Programming-Language`

From here, you can execute the main file and start using NPL.

**Important: NOX Programming Language requires ruby and the gem 'colorize' to be installed!**

`gem install colorize`, if you don't have it installed yet.

## Execution
To execute NPL, you need to run it from the terminal/cmd, as it requires arguments:

- On Windows: `ruby .\nox_exec.rb [params]`
- On Linux: `ruby ./nox_exec.rb [params]`
- On macOS: `ruby ./nox_exec.rb [params]`

### Parameters
NPL is a command-line program. In order to work properly, it requires arguments to be passed.

The basic structure is:
`ruby nox_lang.rb <Method> [Input] [Output]`

#### Method
The method parameter specifies the action the program has to execute. There is a total of **five available values**:

- --help, -h, (empty) => Display the help message
- --compile, -c => Compile [Input], save compiled code to [Output]
- --run, -r => Execute compiled binary file [Input]. Output is not used in this case.
- --decompile, -d => Decompile [Input], save source code to [Output]. Decompilation is not available in the CTF challenge (It was not uploaded to GitHub, so you won't find it here
- --console, -i => Interactive console. Neither [Input] nor [Output] Are used in this scenario. For further reference, see [Interactive Console](Console.md).

#### Input
The input parameter should contain **the path to input file** used in operation.

- --help and --console (and their shortcuts respectively) take no parameters, so should be empty: `nox_exec.rb --help`
- --compile takes the source code and translates it into binary form. In this case, field should contain the path to the source code file: `nox_exec.rb --compile path/to/source_code.npl path/to/binary_code.bin`
- --run takes a binary file as its input, so should look like: `nox_exec.rb --run path/to/binary_code.bin`
- --decompile expects a binary file as input: `nox_exec.rb --decompile path/to/binary_code.bin path/to/source_code.npl`

#### Output
The output behaves similarly to input, except it's the second parameter (excluding method).
For examples, look at **Input**.
