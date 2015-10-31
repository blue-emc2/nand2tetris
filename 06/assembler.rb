#
# メインプログラム
#
require './parser.rb'
require "./code.rb"

class Assembler

  def run(argv)
    raise "not found asm file!" if argv.size.zero?

    parser = Parser.new(argv.first)

    instructions = []
    while parser.hasMoreCommands?
      parser.advance

      type = parser.commandType

      if type == :C_COMMAND
        instruction = "111"
        instruction << Code.comp(parser.comp)
        instruction << Code.dest(parser.dest)
        instruction << Code.jump(parser.jump)
      else
        instruction = parser.symbol
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
end

Assembler.new.run(ARGV)
