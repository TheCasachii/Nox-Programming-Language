require 'colorize'

ERROR_INV_PARAM = 'Error: Invalid parameter given!'                   .red
ERROR_PAR_RANGE = 'Error: Parameter out of range!'                    .red
ERROR_MAC_VIOLT = 'Error: Tried to call "mac" from within a mac!'     .red
ERROR_EXS_NOFIL = 'Error: File does not exist!'                       .red
ERROR_OPC_RANGE = 'Error: Opcode out of range!'                       .red
ERROR_INV_DEALS = 'Error: Invalid DEAL statement!'                    .red
ERROR_PAR_COUNT = 'Error: Parameter not found!'                       .red
ERROR_INT_ERROR = 'Error: Internal error!'                            .red
ERROR_CMD_WRONG = 'Error: Wrong command!'                             .red
ERROR_SIG_FAULT = 'Error: Signature fault!'                           .red
ERROR_IPR_WRONG = 'Error: Wrong IP value!'                            .red
ERROR_LEN_WRONG = 'Error: Wrong length!'                              .red

NULL_CHR        = (0).chr.to_s
MAX_PRGL        = 768
MAX_PRDT        = 256

LEGAL_COMMANDS = %w[nop push pull add sub mod mul div xor and or jmp jc jz jo jnc jnz je in set drop chr out shr shl ain mov cpy hlt callptr]
COMMAND_ARGCNT =   [0,  1,   1,   1,  1,  1,  1,  1,  1,  1,  1, 1,  1, 1, 1, 1,  1,  1, 1, 2,  1,   1,  1,  1,  1,  1,  2,  2  , 1  ]
DEAL_STATES    = %w[error cut]

# Compiler + parser module for Nox Programming Language
# Creation date: 5 Dec 2020
# Fork of the NoxCompile module
# Created by Casachii
module NoxLang
  def self.hex(int)
    x = int.to_s(16)
    '0' * (2 - x.length) + x
  end
  # Method to return NPLIC version
  def self.ic_version
    '1.0'
  end
  # Method to parse int starting with 0x, 0b or no prefix
  def self.parse_int(string)
    base = 10
    base = 2  if string[0, 2] == '0b'
    base = 16 if string[0, 2] == '0x'
    string.to_i base
  end
  # Checks for address being in range
  def self.a_in_range?(addr, memory)
    addr >= 0 && addr < memory.length
  end
  # Checks if value is between 0 and 255
  def self.max255?(val)
    val == val & 0xFF && val >= 0
  end
  # Compiles source code, returns compiled code
  def self.compile(input, output)
    if File.exist?(input)
      data = File.read(input)
      sanitized = []
      line_no = 0
      deal = 'error'
      data.each_line do |line|
        line_no += 1
        l = line.chomp
        next if l.nil? || l.empty?

        words = l.split ' '
        cm = words.shift.downcase
        unless LEGAL_COMMANDS.include? cm
          if cm == 'deal'
            if DEAL_STATES.include? words[0]
              deal = words[0]
              next
            else
              puts ERROR_INV_DEALS
              return
            end
          else
            puts ERROR_OPC_RANGE + cm
            return
          end
        end
        index = LEGAL_COMMANDS.index cm
        parameters_req = COMMAND_ARGCNT[index]
        if words.length < parameters_req
          puts ERROR_PAR_COUNT
          return
        else
          params = []
          set_ptr = parameters_req == 1 && words[0][0, 1] == '*'
          words[0] = words[0][1, words[0].length - 1] if set_ptr
          words[0, parameters_req].each { |word| params << (NoxLang.parse_int word) }
          new_params = []
          params.each do |p|
            if NoxLang.max255? p
              new_params << p
            else
              case deal
              when 'error'
                puts ERROR_PAR_RANGE
                return
              when 'cut'
                new_params << p & 0xFF
              else
                puts ERROR_INT_ERROR
                return
              end
            end
          end
          new_params[1] = 1 if set_ptr
          comm = cm
          comm << " 0x#{new_params[0].to_s(16)}" unless new_params[0].nil?
          comm << " 0x#{new_params[1].to_s(16)}" unless new_params[1].nil? && !set_ptr
          sanitized << comm
        end
      end
      compiled = NULL_CHR * 256
      sanitized.each do |line|
        l = line.chomp.split ' '
        cm = l[0]
        a0 = l[1]
        a0 = '0' if a0.nil?
        a1 = l[2]
        a1 = '0' if a1.nil?
        compiled << (LEGAL_COMMANDS.index cm).chr.to_s
        compiled << (NoxLang.parse_int a0).chr.to_s
        compiled << (NoxLang.parse_int a1).chr.to_s
      end
      trail = NULL_CHR * ((MAX_PRGL + MAX_PRDT - 3) - compiled.length)
      compiled << trail
      checksum0 = NoxLang.get_checksum compiled, 0
      checksum1 = NoxLang.get_checksum compiled, 1
      checksum2 = NoxLang.get_checksum ([checksum0.chr.to_s, checksum1.chr.to_s].join ''), 2
      compiled << checksum0.chr.to_s
      compiled << checksum1.chr.to_s
      compiled << checksum2.chr.to_s

      file = File.open output, 'w'
      file.write compiled
      file.close

      new_c = []

      compiled.each_byte { |b| new_c << b }
      puts "Successfully compiled.".yellow
      new_c
    else
      puts ERROR_EXS_NOFIL
      return
    end
  end
  # Method to calculate checksum based on https://github.com/TheCasachii/Nox-Programming-Language/blob/main/Compile.md#under-the-hood
  def self.get_checksum(string, stage)
    arr = string.split ''
    case stage
    when 0
      sum = 0
      arr.each { |x| sum += x.ord }
      sum &= 255
      result = sum
    when 1
      xor = 0
      arr.each { |x| xor ^= x.ord}
      result = xor
    when 2
      result = ((arr[0].ord + arr[1].ord) & 15)**2
    else
      result = nil
    end
    result
  end
  # Method to check signature
  def self.check_sig (memory)
    program = memory[0, 1021]
    c1 = NoxLang.get_checksum program, 0
    c2 = NoxLang.get_checksum program, 1
    c3 = NoxLang.get_checksum ([c1.chr.to_s, c2.chr.to_s].join ''), 2
    s1 = memory[1021, 1].ord
    s2 = memory[1022, 1].ord
    s3 = memory[1023, 1].ord
    c1 == s1 && c2 == s2 && c3 == s3
  end
  # Method to parse Interactive Console code
  # CTFlearn{Y0u_$h4ll_N3V3R_7ru57_u53r_1npu7}
  # Please don't risk
  def self.parse_ic(content, memory, in_mac)
    data = content.chomp.split ' '
    command = data.shift
    new_memory_state = memory
    unless command.nil?
      case command
      when 'set'
        if data.length == 2
          addr = NoxLang.parse_int data[0]
          val  = NoxLang.parse_int data[1]
          if NoxLang.a_in_range?(addr, memory) && NoxLang.max255?(val)
            new_memory_state[addr] = val
            puts "Written #{val} to cell #{addr}.".yellow
          else
            puts ERROR_PAR_RANGE
          end
        else
          puts ERROR_INV_PARAM
        end
      when 'get'
        if data.length == 1
          addr = NoxLang.parse_int data[0]
          if NoxLang.a_in_range? addr, memory
            val = memory[addr]
            puts "Value at #{addr} is #{val}.".yellow
          else
            puts ERROR_PAR_RANGE
          end
        else
          puts ERROR_INV_PARAM
        end
      when 'mac'
        if in_mac
          puts ERROR_MAC_VIOLT
        else
          if File.exist? data.join
            contents = File.read data.join
            contents.each_line { |line| memory = NoxLang.parse_ic line, memory, true }
          else
            puts ERROR_EXS_NOFIL
          end
        end
      when 'load'
        if File.exist? data.join
          cf = File.open(data.join, 'rb')
          contents = cf.read
          cf.close
          if contents.length == 1024
            if NoxLang.check_sig(contents)
              tmp = []
              contents.each_byte {|x| tmp << x}
              new_memory_state = tmp
              puts 'Loaded file into memory.'.yellow
            else
              puts ERROR_SIG_FAULT
            end
          else
            puts ERROR_PAR_RANGE
          end
        else
          puts ERROR_EXS_NOFIL
        end
      when 'compile'
        if data.length == 2
          input = data[0]
          output = data[1]
          x = NoxLang.compile input, output
          new_memory_state = x unless x.nil?
        end
      when 'exit'
        puts 'Thanks for using NPLIC.'.green
        exit
      when 'run'
        NoxLang.run_active_segment memory
      when 'sig'
        cm = data[0]
        case cm
        when 'update'
          tmp = ''
          memory[0, 1021].each {|x| tmp << x.chr.to_s}
          c0 = NoxLang.get_checksum tmp, 0
          c1 = NoxLang.get_checksum tmp, 1
          c2 = NoxLang.get_checksum ([c0.chr.to_s, c1.chr.to_s].join ''), 2
          new_memory_state[1021] = c0
          new_memory_state[1022] = c1
          new_memory_state[1023] = c2
          puts "Updated the signature to: #{NoxLang.hex(c0)}#{NoxLang.hex(c1)}#{NoxLang.hex(c2)}".yellow
        when 'get'
          puts "The current signature is: #{NoxLang.hex(memory[1021])}#{NoxLang.hex(memory[1022])}#{NoxLang.hex(memory[1023])}"
        when 'set'
          puts 'Warning! Overwriting the signature may render your program unusable!'.yellow
          puts 'Do you really want to proceed? [Y/N]'.yellow
          print '~> '.yellow
          answer = $stdin.gets.chomp
          if answer[0].downcase == 'y'
            print 'Signature (6 hex digits): '.yellow
            sig = $stdin.gets.chomp
            if sig.length == 6
              s0 = sig[0, 2].to_i(16)
              s1 = sig[2, 2].to_i(16)
              s2 = sig[4, 2].to_i(16)
              new_memory_state[1021] = s0
              new_memory_state[1022] = s1
              new_memory_state[1023] = s2
              puts "Updated the signature to: #{sig}, if valid (or zero if invalid).".yellow
            else
              print ERROR_LEN_WRONG
            end
          end
        else
          puts ERROR_CMD_WRONG
        end
      when 'dump'
        if data.join.empty? || data.join.nil?
          puts ERROR_EXS_NOFIL
        else
          file = File.open(data.join, 'wb')
          tmp = ''
          memory.each {|x| tmp << x.chr.to_s}
          file.write tmp
          file.close
          puts 'Memory dump saved to file.'.yellow
        end
      else
        puts ERROR_CMD_WRONG
      end
      new_memory_state
    end
  end
  # Interpreter method
  def self.interprete (memory, ip, a, flags)
    text_mem = []
    memory.each {|x| text_mem << x.chr.to_s}
    if memory.length == 1024
      if ip >= 256 && ip <= 1018
        command = memory[ip] & 0xFF
        p0 = memory[ip +  1] & 0xFF
        p1 = memory[ip +  2] & 0xFF
        p0 = memory[p0] & 0xFF if p1 == 1 && COMMAND_ARGCNT[command] < 2
        case command
        when 0x00
          # NOP
        when 0x01
          # PUSH
          memory[p0] = a
        when 0x02
          # PULL
          a = memory[p0]
        when 0x03
          # ADD
          a += memory[p0]
        when 0x04
          # SUB
          a -= memory[p0]
        when 0x05
          # MOD
          a %= memory[p0]
        when 0x06
          # MUL
          a *= memory[p0]
        when 0x07
          # DIV
          a /= memory[p0] if memory[p0] != 0
          a = a.floor
        when 0x08
          # XOR
          a ^= memory[p0]
        when 0x09
          # AND
          a &= memory[p0]
        when 0x0A
          # OR
          a |= memory[p0]
        when 0x0B
          # JMP
          ip = 256 + p0 * 3
        when 0x0C
          # JC
          ip = 256 + p0 * 3 if flags >> 1 & 1
        when 0x0D
          # JZ
          ip = 256 + p0 * 3 if flags >> 2 & 1
        when 0x0E
          # JO
          ip = 256 + p0 * 3 if flags >> 0 & 1
        when 0x0F
          # JNC
          ip = 256 + p0 * 3 unless flags >> 1 & 1
        when 0x10
          # JNZ
          ip = 256 + p0 * 3 unless flags >> 2 & 1
        when 0x11
          # JE
          ip = 256 + p0 * 3 unless flags >> 0 & 1
        when 0x12
          # IN
          i = $stdin.gets.chomp
          memory[p0] = NoxLang.parse_int(i) & 0xFF unless i.empty?
        when 0x13
          # SET
          memory[p0] = p1
        when 0x14
          # DROP
          memory[p0] = 0
        when 0x15
          # CHR
          print memory[p0].chr.to_s
        when 0x16
          # OUT
          print NoxLang.hex(memory[p0])
        when 0x17
          # SHR
          a = a >> memory[p0]
        when 0x18
          # SHL
          a = a << memory[p0]
        when 0x19
          # AIN
          i = $stdin.gets.chomp
          memory[p0] = i[0, 1].ord unless i.empty?
        when 0x1A
          # MOV
          memory[p1] = memory[p0]
          memory[p0] = 0
        when 0x1B
          # CPY
          memory[p1] = memory[p0]
        when 0x1C
          # HLT
          puts "Program exit with code: 0x#{NoxLang.hex(p0)}"
          return
        when 0x1D
          # CALLPTR
          addr = ((ip - 256) / 3 + 2) & 0xFF
          memory[p0] = addr
        else
          puts ERROR_OPC_RANGE
          return
        end
        [a, ip]
      else
        puts ERROR_IPR_WRONG
      end
    else
      puts ERROR_SIG_FAULT
    end
  end
  # Method to run program loaded in memory
  def self.run_active_segment(memory)
    ip = 256
    a = 0
    flags = 0
    tmp = ''
    memory.each {|x| tmp << x.chr.to_s}
    unless NoxLang.check_sig(tmp)
      puts ERROR_SIG_FAULT
      return
    end
    while true
      res = NoxLang.interprete(memory, ip, a, flags)
      exit if res.nil? || res.empty?
      ip += 3 if ip == res[1]
      ip = 256 if ip > 1018
      a = res[0]
      flags = (a != a & 0xFF) | (a == 0) | (a % 2)
      a %= 256
    end
  end
end
