#
# メインプログラム
#
require './VMtranslator/parser.rb'
require './VMtranslator/code_writer.rb'

class VMTramslator

  # Xxx.vm という名前のファイル
  # ひとつ以上の.vm ファイルを含んだディレクトリのパス
  def run(argv)
    source = argv.first
    dir_name = File.dirname(source)
    if argv[1]
      base_name = argv[1]
    else
      base_name = File.basename(source, ".*")
    end

    if File.directory?(source)
      output_file = "#{dir_name}/#{base_name}/#{base_name}.asm"
      vm_files = Dir.glob("#{source}/*.vm").map{|path| path.gsub("//", "/") }
    else
      output_file = "#{dir_name}/#{base_name}.asm"
      vm_files = [source]
    end

    puts "#{__method__} output_file: #{output_file}"

    code_writer = CodeWriter.new(output_file)
    code_writer.write_init

    parser = Parser.new(vm_files)
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
      when Parser::COMMANDS[:function]
        code_writer.write_function(arg1, arg2)
      when Parser::COMMANDS[:return]
        code_writer.write_return
      when Parser::COMMANDS[:call]
        code_writer.write_call(arg1, arg2)
      else
        raise "error type:#{type}"
      end
    end

    code_writer.close
  end

end



VMTramslator.new.run(ARGV)
