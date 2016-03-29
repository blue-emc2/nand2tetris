#
# メインプログラム
#
require './VMtranslator/parser.rb'
require './VMtranslator/code_writer.rb'
require 'pp'

class VMTramslator

  def run(argv)
    vm_files = Dir.glob("**/*.vm")
    vm_file = vm_files.detect{ |file| File.basename(file) == File.basename(argv.first) }

    dir_name = File.dirname(vm_file)
    base_name = File.basename(vm_file, ".*")

    code_writer = CodeWriter.new("#{dir_name}/#{base_name}.asm")

    parser = Parser.new(vm_file)
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
      when Parser::COMMANDS[:label]
        code_writer.write_label(arg1)
      when Parser::COMMANDS[:if_goto]
        code_writer.write_if(arg1)
      when Parser::COMMANDS[:goto]
        code_writer.write_goto(arg1)
      else
        raise "error type:#{type}"
      end
    end

    code_writer.close
  end

end



VMTramslator.new.run(ARGV)
