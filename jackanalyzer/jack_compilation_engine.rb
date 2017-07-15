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
      case @token_messenger.current_token
      when "static", "field"
        compiled_token_stack << compile_class_var_dec
      when "constructor", "function", "method"
        compiled_token_stack << compile_subroutine_dec
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
  end

  def generate(non_terminal_tag, next_non_terminal_words, *compile_methods)
    tokens = []
    tokens << @token_messenger.non_terminal(non_terminal_tag)

    loop do
      case @token_messenger.current_token
      when "</tokens>", nil
        break
      when *next_non_terminal_words
        tokens << @token_messenger.non_terminal(non_terminal_tag)
        break if compile_methods.compact.empty?

        compile_methods.each do |method|
          tokens << send(method)
        end
        break
      else
        tokens << @token_messenger.terminal
      end
    end

    tokens
  end

  def compile_class_var_dec
    generate("classVarDec", [";"], nil)
  end

  def compile_subroutine_dec
    generate("subroutineDec", ["("], nil)
  end
end
