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
    output_tokens(output)
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

  def compile_subroutine
    while(JackLexer::SUBROUTINE_KEYWORDS.include?(@token.token))
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
    # (t)?
    # t = (type varName) (',' type varName)*
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

  def compile_class_var_dec
    push_non_terminal("classVarDec")
    while(@token.token == JackLexer::STATIC)
      push_tokens_and_advance
      type
      var_name
      # (',' varName)* TODO:あとで実装
      symbol(JackLexer::SEMICOLON)
    end
    push_non_terminal("/classVarDec")
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
    if match?(JackLexer::L_SQUARE_BRACKETS)
      push_tokens_and_advance
      compile_expression
      symbol(JackLexer::R_SQUARE_BRACKETS)
    end
    
    symbol(JackLexer::EQ)
    compile_expression
    symbol(JackLexer::SEMICOLON)
    push_non_terminal("/letStatement")
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

  def compile_expression_list
    push_non_terminal("expressionList")
    push_non_terminal("/expressionList")
  end

  def compile_statements
    push_non_terminal("statements")
    while(current_token_include?(JackLexer::STATEMENT_WORDS))
      statement
    end
    push_non_terminal("/statements")
  end

  def compile_term
    push_non_terminal("term")
    case @token.token
    when JackLexer::KEYWORD_CONSTANT
      push_tokens_and_advance
    when /[:digit:]/
      push_tokens_and_advance
    else
      identifier
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
    identifier # subroutineName
    # (expression list) | (class name | var name) TODO:あとで実装
    symbol(JackLexer::DOT)
    identifier # subroutineName
    symbol(JackLexer::L_ROUND_BRACKET)
    compile_expression_list
    symbol(JackLexer::R_ROUND_BRACKET)
  end

  def compile_return
    push_non_terminal("returnStatement")

    keyword(JackLexer::RETURN)
    # expression? TODO:あとで実装
    symbol(JackLexer::SEMICOLON)

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

  # アルファベット、数字、アンダースコアの文字列
  def identifier?
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

  def push_non_terminal(tag)
    @tokens << Token.new(tag, terminal: false)
  end

  def output_tokens(output)
    space_count = 0
    nonterminal_stack = []

    @tokens.each do |token|
      unless token.terminal
        if nonterminal_stack.last == token.token
          nonterminal_stack.pop
          space_count -= 1 # 出力する前にインデントを上げる

          output.puts(add_indent_to(token.to_xml, space_count))
          puts "tokens : #{add_indent_to(token.to_xml, space_count)}"
        else
          output.puts(add_indent_to(token.to_xml, space_count))
          puts "tokens : #{add_indent_to(token.to_xml, space_count)}"

          nonterminal_stack.push(token.token)
          space_count += 1  # 出力してからインデントを下げる
        end
      else
        output.puts(add_indent_to(token.to_xml, space_count))
        puts "tokens : #{add_indent_to(token.to_xml, space_count)}"
      end
    end
  end

  def add_indent_to(tag, space_count)
    space = " " * (2 * space_count)
    "#{space}#{tag}"
  end
end
