require './VMtranslator/vm_reader.rb'

class Parser

  attr_accessor :commands, :command, :reader, :type, :arg1, :arg2

  COMMANDS = {
    arithmetic: :C_ARITHMETIC,
    push: :C_PUSH,
    pop: :C_POP,
    label: :C_LABEL,
    goto: :C_GOTO,
    if_goto: :C_IF,
    function: :C_FUNCTION,
    return: :C_RETURN,
    call: :C_CALL
  }.freeze

  # 入力ファイル/ストリームを開きパースを行う準備をする
  def initialize(files)
    @reader = VMReader.new
    files.each do |file|
      @reader.open(file)
    end
  end

  # まだコマンドは存在する？
  def has_more_commands?
    @reader.has_more_commands?
  end

  # 入力から次のコマンドを読み、それを現在のコマンドにする
  def advance
    @reader.next_command

    if %i(eq lt gt sub neg and or not add).include?(current_command)
      @type = COMMANDS[:arithmetic]
    else
      @type = COMMANDS[current_command]
    end

    raise "Don't know command: #{current_command.inspect}" unless @type

    unless COMMANDS[:return] == @type
      set_arg1(current_command)
    end

    if [COMMANDS[:push], COMMANDS[:pop], COMMANDS[:function], COMMANDS[:call]].detect{|sym| sym == @type}
      set_arg2
    end
  end

  def current_command
    @reader.current_command.to_sym
  end

  def set_arg1(command)
    @arg1 = (command ? @reader.arg1 : command)
  end

  def set_arg2
    @arg2 = @reader.arg2
  end

  def command_type
    @type
  end
end
