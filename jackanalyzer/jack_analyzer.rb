#
# メインプログラム
#

require_relative "jack_tokenizer"

class JackAnalyzer

  def run(argv)
    exit 1 unless argv.first

    source = argv.first
    dir_name = File.dirname(source)
    base_name = File.basename(source, ".*")

    if File.file?(argv.first)
      output_directory = "#{dir_name}T/"
      output_file_name = "#{base_name}.xml"
      jack_files = [source]
    else
      output_directory = "#{dir_name}/#{base_name}T/"   # 10/SquareT/...
      output_file_name = "#{base_name}.xml"
      # 引数がdirectoryだった場合、指定したdirectory内のjackファイル名を全て取得する
      jack_files = Dir.glob("#{source}/*.jack").map{|path| path.gsub("//", "/") }
    end

    Dir.mkdir(output_directory) unless Dir.exist?(output_directory)

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
