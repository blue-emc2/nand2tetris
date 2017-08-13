require_relative "jack_lexer"
require_relative "token"

class CompilationEngine

  class SymtaxError < StandardError; end

  def initialize(input, output)
    @lexer = JackLexer.new(File.readlines(input))
    @token = @lexer.current_token
    @tokens = []

    begin
      compile_class()
    rescue SyntaxError => e
      puts "#{e.message}, #{e.backtrace}"
    end
      
    puts "-------------------"
    output_tokens
  end

  def output_tokens
    @tokens.each do |token|
      puts "tokens : #{token.to_markup}"
      #output.puts(token)
    end
  end

  def compile_class
    keyword(JackLexer::CLASS)

    identifier
    
    symbol(JackLexer::L_BRACE)

    compile_class_var_dec

    compile_subroutine

    symbol(JackLexer::R_BRACE)
  end

  def compile_subroutine
    while(JackLexer::SUBROUTINE_KEYWORDS.include?(@token.token))
      push_tokens_and_advance

      if match?(JackLexer::VOID)
        push_tokens_and_advance
      else 
        type
      end

      # subroutineName
      identifier

      symbol(JackLexer::L_ROUND_BRACKET)

      compile_parameter_list

      symbol(JackLexer::R_ROUND_BRACKET)

      subroutine_body
    end
  end

  def compile_parameter_list
   # (t)?
   # t = (type varName) (',' type varName)*
  end

  def subroutine_body
    symbol(JackLexer::L_BRACE)

    while(match?(JackLexer::VAR))
      var_dec
    end

    compile_statements
    symbol(JackLexer::R_BRACE)
  end

  def compile_class_var_dec
    while(@token.token == JackLexer::STATIC)
      push_tokens_and_advance
      type
      var_name
      # (',' varName)* TODO:あとで実装
      symbol(JackLexer::SEMICOLON)
    end
  end

  def type
    if JackLexer::TYPES.include?(@token)
      push_tokens_and_advance
      return
    end
    
    identifier # class name TODO:クラス名検索
  end

  def var_name
    identifier
  end

  def var_dec
    keyword(JackLexer::VAR)
    type
    var_name

    # (',' varName)* TODO:あとで実装
    if match?(JackLexer::COMMA)
      push_tokens_and_advance
      var_name
    end

    symbol(JackLexer::SEMICOLON)
  end

  def keyword(text)
    match(text)
  end

  def identifier
    push_tokens_and_advance
  end

  def symbol(text)
    match(text)
  end

  def compile_let
    push_tokens_and_advance
    var_name

    # ([expression])?
    if match?(JackLexer::L_SQUARE_BRACKETS)
      push_tokens_and_advance
      compile_expression
      symbol(JackLexer::R_SQUARE_BRACKETS)
    end
    
    symbol(JackLexer::EQ)
    compile_expression
    symbol(JackLexer::SEMICOLON)
  end

  def compile_expression
    compile_term

    # (op term)*
    while(current_token_include?(JackLexer::OPERATIONS))
      push_tokens_and_advance
      compile_term
    end
  end

  def compile_expression_list
  end

  def compile_statements
    while(current_token_include?(JackLexer::STATEMENT_WORDS))
      statement
    end
  end

  def statement
    case @token.token
    when JackLexer::LET
      compile_let
    when JackLexer::DO
      compile_do
    when JackLexer::RETURN
      compile_return
    when JackLexer::IF
      compile_if
    else
      raise StandardError
    end
  end

  def compile_term
    case @token.token
    when JackLexer::KEYWORD_CONSTANT
      push_tokens_and_advance
    when /[:digit:]/
      push_tokens_and_advance
    else
      identifier
    end
  end

  def compile_do
    keyword(JackLexer::DO)
    subroutine_call
    symbol(JackLexer::SEMICOLON)
  end

  def subroutine_call
    identifier # subroutineName
    # (expression list) | (class name | var name) TODO:あとで実装
    symbol(JackLexer::DOT)
    identifier # subroutineName
    symbol(JackLexer::L_ROUND_BRACKET)
    compile_expression_list
    symbol(JackLexer::R_ROUND_BRACKET)
  end

  def compile_return
    keyword(JackLexer::RETURN)
    # expression? TODO:あとで実装
    symbol(JackLexer::SEMICOLON)
  end

  def compile_if
    match(JackLexer::IF)
    symbol(JackLexer::L_ROUND_BRACKET)
    compile_expression
    symbol(JackLexer::R_ROUND_BRACKET)

    symbol(JackLexer::L_BRACE)
    compile_statements
    symbol(JackLexer::R_BRACE)

    if match?(JackLexer::ELSE)
      push_tokens_and_advance
      symbol(JackLexer::L_BRACE)
      compile_statements
      symbol(JackLexer::R_BRACE)
    end
  end

  # アルファベット、数字、アンダースコアの文字列
  def identifier?
  end

  # 名前が微妙だが例外を投げたい
  def match(text)
    if match?(text)
      push_tokens_and_advance
    else
      raise SyntaxError, "expecting #{@token.token}, found #{text.inspect}"
    end
  end

  def match?(text)
    puts "match? token: #{@token.inspect}, text: #{text.inspect}"
    @token.token == text
  end

  def push_tokens_and_advance
    @tokens << @lexer.current_token
    @token = @lexer.advance   # 次のトークンを受け取っておく
  end

  def current_token_include?(texts)
    puts "current_token_include: args=#{texts}, token=#{@token.token}"
    texts&.include?(@token.token)
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
