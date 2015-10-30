#
# Parser
# 主な機能は各アセンブリコマンドをフィールドとシンボルに分解することである
#
require "./row.rb"
require "./code.rb"

class Parser

  attr_accessor :asm_file, :command, :type

  COMMANDS = {
    a: :A_COMMAND,
    c: :C_COMMAND,
    l: :L_COMMAND
  }

  # 入力ファイル/ストリームを開きパースを行う準備をする
  def initialize(file)
    @asm_file = File.open(file)
  end

  def advance
    instructions = []
    until hasMoreCommands?
      row = Row.new(@asm_file.gets)
      next if row.skip_line?

      @command = row.text
      @type = commandType

      puts "#{__method__}: #{row.text.inspect}, type:#{type}"

      if @type == :C_COMMAND
        instruction = "111"
        instruction << Code.comp(comp)
        instruction << Code.dest(dest)
        instruction << Code.jump(jump)
      else
        instruction = symbol
      end

      puts "#{__method__}: instruction:#{instruction}, #{instruction.size}"
      instructions << instruction
    end
    puts "instructions: #{instructions}"

    hack_file_name = File.basename(@asm_file.path, ".*")
    dir = File.dirname(@asm_file.path)

    hack_file = File.open("#{dir}/org_#{hack_file_name}.hack", "w")
    instructions.each do |instruction|
      hack_file.write("#{instruction}\n")
    end
  end

  def dest
    if @command.include?("=")
      @command.split("=").first
    end
  end

  def comp
    if @command.include?("=")
      @command.split("=").last
    end
  end

  def jump
    if @command.include?(";")
      nil
    end
  end

  def symbol
    # 今はシンボルを見ない
    "%016b" % @command.delete("@").to_i
  end

  def hasMoreCommands?
    @asm_file.eof?
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
      raise
    end
  end
end
