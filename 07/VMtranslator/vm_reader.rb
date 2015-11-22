#
# いい名前が思いつかなかった
# *.vmファイルを読み込んで、コマンドを返す
#
class VMReader

  attr_accessor :codes, :current_commands

  def initialize(file)
    @codes = []
    File.open(file).each_line do |code|
      next if skip_line?(code)
      @codes << code.chomp
    end

    puts "#{__method__} codes: #{@codes}"
  end

  def has_more_commands?
    !@codes.empty?
  end

  def next_command
    commands = @codes.shift
    puts "#{__method__} commands: #{commands}"
    @current_commands = commands.split unless commands.nil?
  end

  def current_command
    @current_commands.first
  end

  def arg1
    @current_commands[1]
  end

  def arg2
    @current_commands[2]
  end

  private

  def skip_line?(code)
    code.chomp.gsub(" ", "").empty? || code.start_with?('//')
  end

end
