#
# Parser
# 主な機能は各アセンブリコマンドをフィールドとシンボルに分解することである
#
require "./row.rb"
require "./symbol_table.rb"

class Parser

  attr_accessor :asm_file, :commands, :command, :symbol_table, :address

  COMMANDS = {
    a: :A_COMMAND,
    c: :C_COMMAND,
    l: :L_COMMAND
  }

  # 入力ファイル/ストリームを開きパースを行う準備をする
  def initialize(file)
    texts = File.open(file).readlines
    _codes = texts.select {|code| !skip_line?(code)}.map{|code| code.chomp}
    @commands = _codes.map{|code| code.empty? ? nil : code}.compact
    @command = ""
    @symbol_table = SymbolTable.new
    @address ||= 0
  end

  def hasMoreCommands?
    @commands[@address] ? true : false
  end

  def advance
    @command = @commands[@address]
    @address += 1
    puts "#{__method__}: command:#{@command}, address:#{@address}"
  end

  def dest
    if @command.include?("=")
      @command.split("=").first
    end
  end

  def comp
    if @command.include?("=")
      @command.split("=").last
    elsif @command.include?(";")
      @command.split(";").first
    end
  end

  def jump
    if @command.include?(";")
      @command.split(";").last
    end
  end

  def symbol
    "%016b" % @command.delete("@").to_i
  end

  def commandType
    case @command
    when /\A@/
      COMMANDS[:a]
    when /\A\(/
      COMMANDS[:l]
    when /=|\+|;/
      COMMANDS[:c]
    else
      raise "Do not command: #{@command}"
    end
  end

  private

  def skip_line?(code)
    code.gsub(" ", "").empty? || code.include?('//')
  end
end
