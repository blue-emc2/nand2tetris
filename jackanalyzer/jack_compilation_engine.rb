require_relative "lib/token_messenger"

class CompilationEngine

  def initialize(input, output)
    @token_messenger = TokenMessenger.new(File.readlines(input)[1..-1])

    @compiled_file = output
    compile_class()
  end

  def compile_class
    compiled_token_stack = []

    # class tag
    compiled_token_stack << @token_messenger.non_terminal("class")

    loop do
      token = @token_messenger.current_token
      puts token
      case token
      when "static", "field"
        compiled_token_stack << compile_class_var_dec
      when "</tokens>", nil
        break
      else
        # class, class name, symbol
        compiled_token_stack << @token_messenger.terminal
      end
    end

    compiled_token_stack << @token_messenger.non_terminal("class")

    compiled_token_stack.each do |token|
      @compiled_file.puts(token)
    end

    exit
  end

  def compile_class_var_dec
    class_var_dec_tokens = []
    class_var_dec_tokens << @token_messenger.non_terminal("classVarDec")

    loop do
      class_var_dec_tokens << @token_messenger.terminal
      break if [";", "</tokens>"].include?(@token_messenger.current_token)
    end

    class_var_dec_tokens
  end
end
