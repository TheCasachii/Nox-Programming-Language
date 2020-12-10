#!/usr/bin/env ruby
require './nox_lang'

def help
  puts "\nUsage: ruby nox_exec.rb <METHOD> [INPUT_PATH] [OUTPUT_PATH]"
  puts "\nMethods:"
  puts "\t--help, -h - display this message"
  puts "\t--compile, -c - compile input file, save in output file"
  puts "\t--run, -r - run compiled binary"
  puts "\t--decompile, -d - decompile input file, save in output file (removed from CTF challenge)"
  puts "\t--console, -i - interactive console, useful for modifying code before execution or running macros (.mac)"
  puts "For more help, please refer to https://github.com/TheCasachii/Nox-Programming-Language.\n\n"

  exit
end

def welcome_ic
  puts "\nCopyright (C) 2020 Casachii"
  puts "\nLicensed under GNU General Public License 3.0"
  puts "\nNox Interactive Console"
  puts "\nVersion #{NoxLang.ic_version}\n\n"
end

# Get arguments

meth = ARGV[0]
inp  = ARGV[1]
out  = ARGV[2]

# Define global variables

memory = [0] * 1024     # 1KB of RAM (data + code)

# Parse arguments

help if ARGV.length.zero? || ['-h', '--help'].include?(meth)

if ['--compile', '-c'].include?(meth)
  # We are compiling
  NoxLang.compile inp, out
elsif ['--run', '-r'].include?(meth)
  # We run the code
  NoxLang.run_active_segment NoxLang.parse_ic("load #{inp}", memory, false)
elsif ['--decompile', '-d'].include?(meth)
  # Decompilation
  # You don't see anything here, huh!?

elsif ['--console', '-i'].include?(meth)
  # This code is IC
  welcome_ic
  while true
    print '~> '.blue
    n3v3r_tru5t_u53r_1npu7 = $stdin.gets
    memory = NoxLang.parse_ic(n3v3r_tru5t_u53r_1npu7, memory, false)
  end
else
  help
end
