#
# Parser
# 主な機能は各アセンブリコマンドをフィールドとシンボルに分解することである
#
require 'pp'

class Parser

  attr_accessor :asm_file, :commands, :command, :index

  COMMANDS = {
    a: :A_COMMAND,
    c: :C_COMMAND,
    l: :L_COMMAND
  }

  # 入力ファイル/ストリームを開きパースを行う準備をする
  def initialize(file)
    texts = File.open(file).readlines
    codes = texts.select{|code| !skip_line?(code)}
    codes = codes.map do |code|
      c = code
      if code.include?("//")
        c = code.split("//").first
      end
      c.gsub(" ", "").chomp
    end

    @commands = codes.map{|code| code.empty? ? nil : code}.compact
    puts "#{__method__} size: #{@commands.size}, commands: #{@commands}"

    @command = ""
    @index = 0
  end

  # まだコマンドは存在する？
  def hasMoreCommands?
    @commands.size > @index ? true : false
  end

  # 入力から次のコマンドを読み、それを現在のコマンドにする
  def advance
    @command = @commands[@index]
    puts "#{__method__}: command #{@command}, index #{@index}"
    @index += 1
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

  # 現コマンド@XXX、(XXX)のXXXの部分を返す
  def symbol
    command = @command
    if command.include?("@")
      command.delete("@")
    elsif command.include?("(")
      command.gsub(/\(|\)/, "")
    end
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
      raise "Do not command: #{@command.inspect}"
    end
  end

  private

  def skip_line?(code)
    code.gsub(" ", "").empty? || code.start_with?('//')
  end
end
