require_relative "jack_lexer"
require_relative "token"
require_relative "symbol_table"

class CompilationEngine

  class SymtaxError < StandardError; end

  def initialize(input, output)
    @output = output
    @lexer = JackLexer.new(File.readlines(input))
    @token = @lexer.current_token
    @tokens = []
    @symbol_table = SymbolTable.new

    begin
      compile_class()
    rescue SyntaxError => e
      puts "#{e.message}, #{e.backtrace}"
    end
      
    puts "-------------------"
    output_tokens
  end

  def compile_class
    push_non_terminal("class")

    keyword(JackLexer::CLASS)

    identifier
    
    symbol(JackLexer::L_BRACE)

    compile_class_var_dec

    compile_subroutine

    symbol(JackLexer::R_BRACE)
    
    push_non_terminal("/class")
  end

  def compile_class_var_dec
    while(current_token_include?([JackLexer::STATIC, JackLexer::FIELD]))
      push_non_terminal("classVarDec")
      push_tokens_and_advance
      type
      var_name

      while(match?(JackLexer::COMMA))
        symbol(JackLexer::COMMA)
        var_name
      end

      symbol(JackLexer::SEMICOLON)
      push_non_terminal("/classVarDec")
    end
  end

  def compile_subroutine
    while(current_token_include?(JackLexer::SUBROUTINE_KEYWORDS))
      push_non_terminal("subroutineDec")
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
      push_non_terminal("/subroutineDec")
    end
  end

  def compile_parameter_list
    push_non_terminal("parameterList")
    # ((type varName) (',' type varName)*)?
    if current_token_include?(JackLexer::TYPES)
			type
      var_name

      while(match?(JackLexer::COMMA))
        symbol(JackLexer::COMMA)
        type
        var_name
      end
		end
    push_non_terminal("/parameterList")
  end

  def subroutine_body
    push_non_terminal("subroutineBody")
    symbol(JackLexer::L_BRACE)

    while(match?(JackLexer::VAR))
      var_dec
    end

    compile_statements
    symbol(JackLexer::R_BRACE)
    push_non_terminal("/subroutineBody")
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
    push_non_terminal("varDec")
    keyword(JackLexer::VAR)
    type
    var_name

    # (',' varName)* TODO:あとで実装
    if match?(JackLexer::COMMA)
      push_tokens_and_advance
      var_name
    end

    symbol(JackLexer::SEMICOLON)
    push_non_terminal("/varDec")
  end

  def compile_let
    push_non_terminal("letStatement")
    push_tokens_and_advance
    var_name

    # ([expression])?
    if match?(JackLexer::L_SQUARE_BRACKET)
      push_tokens_and_advance
      compile_expression
      symbol(JackLexer::R_SQUARE_BRACKET)
    end
    
    symbol(JackLexer::EQ)
    compile_expression
    symbol(JackLexer::SEMICOLON)
    push_non_terminal("/letStatement")
  end

  # (expression (',' expression)* )?
  def compile_expression_list
    push_non_terminal("expressionList")

    unless match?(JackLexer::R_ROUND_BRACKET)
      compile_expression
      while match?(JackLexer::COMMA)
        symbol(JackLexer::COMMA)
        compile_expression
      end
    end

    push_non_terminal("/expressionList")
  end

  def compile_statements
    push_non_terminal("statements")
    while(current_token_include?(JackLexer::STATEMENT_WORDS))
      statement
    end
    push_non_terminal("/statements")
  end

  def compile_expression
    push_non_terminal("expression")
    compile_term

    # (op term)*
    while(current_token_include?(JackLexer::OPERATIONS))
      push_tokens_and_advance
      compile_term
    end
    push_non_terminal("/expression")
  end

  def compile_term
    push_non_terminal("term")
    case @token.token
    when JackLexer::KEYWORD_CONSTANT
      push_tokens_and_advance
    when /[[:digit:]]/
      push_tokens_and_advance
    when JackLexer::L_ROUND_BRACKET
      symbol(JackLexer::L_ROUND_BRACKET)
      compile_expression
      symbol(JackLexer::R_ROUND_BRACKET)
    when JackLexer::NEGATIVE, JackLexer::TILDE
      # unaryOp term
      symbol(match?(JackLexer::NEGATIVE) ? JackLexer::NEGATIVE : JackLexer::TILDE)
      compile_term
    else
      if next_token_match?(JackLexer::DOT)
        subroutine_call
      elsif next_token_match?(JackLexer::L_SQUARE_BRACKET)
        # varName [ expression ]
        var_name
        symbol(JackLexer::L_SQUARE_BRACKET)
        compile_expression
        symbol(JackLexer::R_SQUARE_BRACKET)
      elsif next_token_match?(JackLexer::L_ROUND_BRACKET)
        symbol(JackLexer::L_ROUND_BRACKET)
        compile_expression
        symbol(JackLexer::R_ROUND_BRACKET)
      else
        identifier
      end
    end

    push_non_terminal("/term")
  end

  def compile_do
    push_non_terminal("doStatement")
    keyword(JackLexer::DO)
    subroutine_call
    symbol(JackLexer::SEMICOLON)
    push_non_terminal("/doStatement")
  end

  def subroutine_call
    if next_token_match?(JackLexer::L_ROUND_BRACKET)
      identifier # subroutineName
      symbol(JackLexer::L_ROUND_BRACKET)
      compile_expression_list
      symbol(JackLexer::R_ROUND_BRACKET)
    else
      #  (class name | var name) TODO:あとで実装
      var_name

      symbol(JackLexer::DOT)
      identifier # subroutineName
      symbol(JackLexer::L_ROUND_BRACKET)
      compile_expression_list
      symbol(JackLexer::R_ROUND_BRACKET)
    end
  end

  def compile_return
    push_non_terminal("returnStatement")

    keyword(JackLexer::RETURN)

    if match?(JackLexer::SEMICOLON)
      symbol(JackLexer::SEMICOLON)
    else
      compile_expression
      symbol(JackLexer::SEMICOLON)
    end

    push_non_terminal("/returnStatement")
  end

  def compile_if
    push_non_terminal("ifStatement")
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
    push_non_terminal("/ifStatement")
  end

  def compile_while
    push_non_terminal("whileStatement")
    match(JackLexer::WHILE)
    symbol(JackLexer::L_ROUND_BRACKET)
    compile_expression
    symbol(JackLexer::R_ROUND_BRACKET)
    symbol(JackLexer::L_BRACE)
    compile_statements
    symbol(JackLexer::R_BRACE)
    push_non_terminal("/whileStatement")
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
    when JackLexer::WHILE
      compile_while
    else
      raise StandardError, "token: #{@token.token}"
    end
  end

  def keyword(text)
    match(text)
  end

  def identifier
    push_tokens_and_advance
    symbol_table
  end

  def symbol_table
    push_non_terminal("symbolTable")
    @tokens << @symbol_table
    push_non_terminal("/symbolTable")
  end

  def symbol(text)
    match(text)
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
#    puts "current_token_include: args=#{texts}, token=#{@token.token}"
    texts&.include?(@token.token)
  end

  def next_token_match?(candidacy)
    puts "next_token: #{@lexer.next_token.token}, current: #{@token.token}, candidacy: #{candidacy}"
    @lexer.next_token.token == candidacy
  end

  def push_non_terminal(tag)
    @tokens << Token.new(tag, terminal: false)
  end

  def output_tokens
    @tokens.each.with_index(1) do |token, i|
      #@output.puts(token.to_xml)
      puts "#{i} : tokens = #{token.to_xml}"
    end
  end
end
