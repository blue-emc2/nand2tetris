require_relative "jack_lexer"
require_relative "token"

class CompilationEngine

  class SymtaxError < StandardError; end

  def initialize(input, output)
#    @token_messenger = TokenMessenger.new(File.readlines(input)[1..-1])

    @lexer = JackLexer.new(File.readlines(input))
    @token = @lexer.current_token
    @tokens = []

    compile_class()

    @tokens.each do |token|
      puts "-------------------"
      puts "tokens : #{token.to_markup}"
      #output.puts(token)
    end
  end

  def compile_class
    keyword(JackLexer::CLASS)

#    identifier
#    
#    symbol(Lexer.L_BRACES)
#
#    compile_class_var_dec
#
#    compile_subroutine_dec
#
#    symbol(Lexer.R_BRACES)

#    while @token != Lexer.EOF
#      @token = @lexer.advance
#    end
#
#    tokens = []
#    if match_keyword?("class")
#      tokens << @lexer.verified_token
#    end
#
#    @lexer.match_keyword?
#
#    if match_identifier?("Main")
#      tokens << @lexer.verified_token
#    end
  end

  def compile_class_var_dec
    # static | field
    # type
    # var name
    # (',')*
    # ';'
  end

  def compile_subroutine_dec
    # ('constructor' | 'function' | 'method')
    # ('void' | type)
    # subroutineName
    # '('
    parameter_list
    # ')'
    subroutine_body
  end

  def parameter_list
   # (t)?
   # t = (type varName) (',' type varName)*
  end

  def subroutine_body
    # '{'
    # varDec* statements
    # '}'
  end

  private

  def keyword(text)
    if match?(text)
      push_tokens_and_advance
    end
  end

  def match?(text)
    puts "match?  token: #{@token}, text: #{text}"
    if @token.token == text
      return true
    else
      raise SyntaxError, "expecting #{text.inspect}; found #{@token.inspect}"
    end
  end

  def push_tokens_and_advance
    @tokens << @lexer.current_token
    @lexer.advance
  end

  def match_identifier?(token)
    @lexer.match?(token)
  end

=begin
  def compile_class
    compiled_token_stack = []

    # class tag
    compiled_token_stack << @token_messenger.non_terminal("class")

    compiled_token_stack << @token_messenger.terminal
    compiled_token_stack << @token_messenger.terminal
    compiled_token_stack << @token_messenger.terminal


    loop do
      token = @token_messenger.look_ahead_token
      puts "token: #{token}"
      case token
      # when "static", "field"
      #   compiled_token_stack << compile_class_var_dec
      # when "constructor", "function", "method"
      #   compiled_token_stack << compile_subroutine_dec
      when "</tokens>", nil
        break
      else
        # class, class name, {
        # compiled_token_stack << @token_messenger.terminal
      end

      @token_messenger.position += 1
    end

    compiled_token_stack << @token_messenger.non_terminal("class")

    compiled_token_stack.each do |token|
      @compiled_file.puts(token)
    end
  end

  def generate(non_terminal_tag=nil, token_key_call_methods={})
    keys = token_key_call_methods.keys
    tokens = []

    if block_given?
      tokens << yield
      return tokens
    end

    tokens << @token_messenger.non_terminal(non_terminal_tag)
    tokens << @token_messenger.terminal

    loop do
      token = @token_messenger.current_token
      puts "#generate token : #{token}, #{keys}, #{keys.include?(token)}"
      case token
      when "</tokens>", nil
        break
      when *keys
        tokens << @token_messenger.terminal
        if token_key_call_methods[token]
          # tokenに対応するメソッドを呼び出す
          tokens << send("compile_#{token_key_call_methods[token]}")
        end

        tokens << @token_messenger.non_terminal(non_terminal_tag)
        break
      else
        tokens << @token_messenger.terminal
      end

      # @token_messenger.position += 1
    end

    tokens
  end

  def compile_class_var_dec
    generate("classVarDec", {"\;" => nil})
  end

  def compile_subroutine_dec
    generate("subroutineDec", {
      "(" => :parameter_list,
      ")" => :subroutine_body
    })
  end

  # <parameterList> ... </parameterList>を返す
  def compile_parameter_list
    generate do
      tokens = []
      tokens << @token_messenger.non_terminal("parameterList")

      loop do
        case @token_messenger.look_ahead_token
        when ")"
          tokens << @token_messenger.non_terminal("parameterList")
          break
        else
          tokens << @token_messenger.terminal
        end

        # @token_messenger.position += 1
      end

      tokens
    end
  end
=end
end
