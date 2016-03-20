require './VMtranslator/vm_reader.rb'
require 'pp'

class Parser

  attr_accessor :commands, :command, :reader, :type, :arg1, :arg2

  COMMANDS = {
    arithmetic: :C_ARITHMETIC,
    push: :C_PUSH,
    pop: :C_POP,
    label: :C_LABEL,
    goto: :C_GOTO,
    if: :C_IF,
    function: :C_FUNCTION,
    return: :C_RETURN,
    call: :C_CALL
  }.freeze

  # 入力ファイル/ストリームを開きパースを行う準備をする
  def initialize(file)
    @reader = VMReader.new(file)
  end

  # まだコマンドは存在する？
  def has_more_commands?
    @reader.has_more_commands?
  end

  # 入力から次のコマンドを読み、それを現在のコマンドにする
  def advance
    @reader.next_command

    @type = case current_command
            when "push"
              COMMANDS[:push]
            when "pop"
              COMMANDS[:pop]
            when "eq", "lt", "gt", "sub", "neg", "and", "or", "not", "add"
              COMMANDS[:arithmetic]
            else
              raise "Don't know command: #{current_command.inspect}"
            end

    unless COMMANDS[:return] == @type
      if COMMANDS[:arithmetic] == @type
        arg1(current_command)
      else
        arg1
      end
    end

    if [COMMANDS[:push], COMMANDS[:pop], COMMANDS[:function], COMMANDS[:call]].detect{|sym| sym == @type}
      puts "arg2 type: #{@type}"
      arg2
    end
  end

  def current_command
    @reader.current_command
  end

  def arg1(command = nil)
    if command.nil?
      @arg1 = @reader.arg1
    else
      @arg1 = command
    end
  end

  def arg2
    @arg2 = @reader.arg2
  end

  def command_type
    @type
  end
end
