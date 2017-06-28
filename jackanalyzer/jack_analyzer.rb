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

    output_file_name = "#{base_name}.xml"

    if File.directory?(source)
      output_directory = "#{dir_name}/#{base_name}Test/"
      Dir.mkdir(output_directory) unless Dir.exist?(output_directory)
      jack_files = Dir.glob("#{source}/*.jack").map{|path| path.gsub("//", "/") }
    else
      output_directory = "#{dir_name}Test/"
      jack_files = [source]
    end

    puts "#{__method__} output_file: #{output_directory}, #{output_file_name}, #{jack_files}"

    jack_files.each do |jack_file|
      parser = File.open("#{output_directory}#{File.basename(jack_file, ".*")}.xml", "w")

      tokenizer = JackTokenizer.new(jack_file)
      engine = CompilationEngine.new(tokenizer, parser)
    end
  end
end

JackAnalyzer.new.run(ARGV)
