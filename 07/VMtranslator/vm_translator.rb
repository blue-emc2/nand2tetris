#
# メインプログラム
#
require './parser.rb'
require './code_writer.rb'
require 'pp'

class VMTramslator

  def run(argv)
    raise "not found *.vm file!" if argv.size.zero?

    dir_name = File.dirname(argv.first)
    base_name = File.basename(argv.first, ".*")
    code_writer = CodeWriter.new("#{dir_name}/#{base_name}.asm")

    parser = Parser.new(argv.first)
    while parser.has_more_commands?
      parser.advance

      type = parser.command_type
      puts "#{__method__} type: #{type}"

      command = parser.current_command
      puts "#{__method__} command:#{command}"

      arg1 = parser.arg1
      arg2 = parser.arg2
      puts "#{__method__} arg1:#{arg1}, arg2:#{arg2}"

      case type
      when Parser::COMMANDS[:push], Parser::COMMANDS[:pop]
        code_writer.write_push_pop(type, arg1, arg2)
      when Parser::COMMANDS[:arithmetic]
        code_writer.write_arithmetic(command)
      else
        raise
      end
    end

    code_writer.close
  end

end



VMTramslator.new.run(ARGV)
