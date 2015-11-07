#
# メインプログラム
#
require './parser.rb'
require "./code.rb"
require "./symbol_table.rb"
require 'pp'

class Assembler

  def run(argv)
    raise "not found asm file!" if argv.size.zero?

    parser = Parser.new(argv.first)
    symbol_table = SymbolTable.new
    address = 0
    while parser.hasMoreCommands?
      parser.advance

      if parser.commandType == :L_COMMAND
        # ここでは+1しない。なぜなら、バイナリした時にここの擬似コマンドがなくなり、次の命令になるから。
        symbol_table.add_entry(parser.symbol, address)
      else
        address += 1
      end
    end

    puts "#{__method__} symbol_table: #{symbol_table.inspect}"

    parser = Parser.new(argv.first)

    variable_address = 16

    instructions = []
    while parser.hasMoreCommands?
      parser.advance

      type = parser.commandType

      if type == :C_COMMAND
        instruction = "111"
        instruction << Code.comp(parser.comp)
        instruction << Code.dest(parser.dest)
        instruction << Code.jump(parser.jump)
      elsif type == :A_COMMAND
        symbol = parser.symbol

        if symbol_table.contains(symbol)
          address = symbol_table.get_address(symbol)
          instruction = "%016b" % address.to_i
          puts "A_COMMAND 1 address: #{address}, symbol: #{symbol}"
        else
          puts "A_COMMAND 2 symbol: #{symbol}"

          if integer_only?(symbol)
            # 10進数
            instruction = "%016b" % symbol.to_i
          else
            instruction = "%016b" % variable_address.to_i
            # 変数をシンボルテーブルに追加
            symbol_table.add_entry(parser.symbol, variable_address)
            variable_address += 1
          end
        end
      elsif type == :L_COMMAND
        puts "L_COMMAND symbol: #{parser.symbol}"
        next
      end

      puts "#{__method__}: instruction:#{instruction}, #{instruction.size}"

      instructions << instruction
    end

    out_put_hack(argv.first, instructions)
  end

  def out_put_hack(path, instructions)
    hack_file_name = File.basename(path, ".*")
    dir = File.dirname(path)

    hack_file = File.open("#{dir}/org_#{hack_file_name}.hack", "w")
    instructions.each do |instruction|
      hack_file.write("#{instruction}\n")
    end
  end

  def integer_only?(symbol)
    Integer(symbol)
    true
  rescue ArgumentError
    false
  end
end

Assembler.new.run(ARGV)
