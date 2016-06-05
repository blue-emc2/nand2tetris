#
# メインプログラム
#

require './jackanalyzer/compilation_engine.rb'

class JackAnalyzer

  def run(argv)
    source = argv.first
    dir_name = File.dirname(source)
    if argv[1]
      base_name = argv[1]
    else
      base_name = File.basename(source, ".*")
    end

    output_directory = "#{dir_name}/#{base_name}Test/"
    output_file_name = "#{base_name}.xml"

    if File.directory?(source)
      Dir.mkdir(output_directory) unless Dir.exist?(output_directory)
      jack_files = Dir.glob("#{source}/*.jack").map{|path| path.gsub("//", "/") }
    else
      jack_files = [source]
    end

    puts "#{__method__} output_file: #{output_directory}, #{output_file_name}, #{jack_files}"

    jack_files.each do |jack_file|
      writer = File.open("#{output_directory}#{File.basename(jack_file, ".*")}T.xml", "w")
      writer.puts("<tokens>\r")

      tokenizer = JackTokenizer.new(jack_file)

      while tokenizer.has_more_commands?
        tokenizer.advance

        # token_typeでtypeとtokenを一度に返せるが本のとおりに実装する
        type = tokenizer.token_type
        token = case type
                when :keyword
                  tokenizer.keyword
                when :symbol
                  tokenizer.symbol
                when :identifier
                  tokenizer.identifier
                when :integerConstant
                  tokenizer.int_val
                when :stringConstant
                  tokenizer.string_val
                else
                  puts "error: #{type.inspect}, #{token.inspect}"
                end

        # puts "type: #{type}"
        # puts "token: #{token}"
        writer.puts("<#{type}> #{token} </#{type}>\r")
      end

      writer.puts("</tokens>\r")
    end
  end
end

JackAnalyzer.new.run(ARGV)
