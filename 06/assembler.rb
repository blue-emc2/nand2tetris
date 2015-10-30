#
# メインプログラム
#
require './parser.rb'

class Assembler

  def self.run(argv)
    raise "not found asm file!" if argv.size.zero?

    parser = Parser.new(argv.first)
    parser.advance
  end

end

Assembler.run(ARGV)
