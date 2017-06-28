require_relative 'jack_tokenizer'
require_relative 'jack_constants'
require_relative 'jack_class'
require_relative 'element/jack_calss'
require_relative 'element/class_var_dec'
require_relative 'element/subroutine_dec'

class CompilationEngine

  include JackConstants

  def initialize(input, output)
    @tokenizer = input
    @output = output
    @elemtns = []
    @indent = 0
    compile_class
  end

  def compile_subroutine_body
    begin_non_terminal("subroutineBody")
    # {
    push_terminal

    while match_next_token_type?(%i(keyword))
      compile_var_dec

      break if match_next_token_type?(%i(keyword), "let")
    end

    compile_statements

    end_non_terminal("subroutineBody")
  end

  def compile_statements
    begin_non_terminal("statements")

    while match_next_token_type?(%i(keyword))
      compile_let
    end

    end_non_terminal("statements")
  end

  def compile_let
    begin_non_terminal("letStatement")
    # let
    push_terminal
    # var name
    push_terminal
    # =
    push_terminal
    # expression
    compile_expression

    # ;
    push_terminal
    end_non_terminal("letStatement")
  end

  def compile_expression
    begin_non_terminal("expression")
    compile_term
    # compile_expression_list
    end_non_terminal("expression")
  end

  def compile_expression_list
    begin_non_terminal("expressionList")
    compile_term
    # compile_expression
    end_non_terminal("expressionList")
  end

  def compile_term
    begin_non_terminal("term")

    puts "------"
    while match_next_token_type?(%i(identifier symbol))
      puts "@    ------"

      if next_token_dot?
        puts "dot"
        push_terminal

        # 8/23 セミコロンがでてくるまで出力するというロジックを書いていたらしい
        # セミコロンがくるまで主力する
        # (が来たらexpressionList

        until match_next_token_type?(%i(symbol), ";")
          push_terminal
          # if
        end


        break
      elsif next_token_brackets?
        puts "brackets"
        break
      elsif next_token_square_brackets?
        puts "square"
        break
      else
        puts "else"
        push_terminal
      end
    end

    end_non_terminal("term")
  end

  def compile_var_dec
    begin_non_terminal("varDec")

    # ;を探す
    until match_next_token_type?(%i(symbol), ";")
      push_terminal
    end

    # ;
    push_terminal
    end_non_terminal("verDec")
  end

  def compile_parameter_list
    begin_non_terminal("parameterList")
    return end_non_terminal("parameterList") if match_next_token_type?(%i(symbol))
  end

  def compile_subroutine
    # begin_non_terminal("subroutineDec")

    # # method type
    # push_terminal

    # # return type
    # push_terminal

    # # name
    # push_terminal

    # # (
    # push_terminal

    # # parameter list
    # compile_parameter_list

    # # )
    # push_terminal

    # # body
    # compile_subroutine_body

    # end_non_terminal("subroutineDec")

    subroutine_dec = Module.const_get("SubroutineDec").new
    subroutine_dec.begin_tag

    while true
      result, reason = subroutine_dec.create_jack_element(*advance)
      unless result
        @tokenizer.position -= 1  # 解析不可なtokenが来たらposiotionを戻しておく
        subroutine_dec.end_tag
        break
      end
    end

    @output.puts(subroutine_dec.dump)
  end

  def compile_class_var_dec
    class_var_dec = Module.const_get("ClassVarDec").new
    class_var_dec.begin_tag

    while true
      result, reason = class_var_dec.create_jack_element(*advance)
      unless result
        @tokenizer.position -= 1  # 解析不可なtokenが来たらposiotionを戻しておく
        class_var_dec.end_tag
        break
      end
    end

    @output.puts(class_var_dec.dump)
  end

  def compile_class
    jack_class = Module.const_get("JackClass").new
    jack_class.begin_tag

    while true
      result = jack_class.create_class_element(*advance)
      unless result
        @tokenizer.position -= 1  # 解析不可なtokenが来たらposiotionを戻しておく
        jack_class.end_tag
        break
      end
    end

    @output.puts(jack_class.dump)

    compile_class_var_dec

    compile_subroutine
  end

  def advance
    @tokenizer.advance

    type = @tokenizer.token_type
    token = case type
            when :keyword
              @tokenizer.keyword
            when :symbol
              @tokenizer.symbol
            when :identifier
              @tokenizer.identifier
            when :integerConstant
              @tokenizer.int_val
            when :stringConstant
              @tokenizer.string_val
            else
              raise "error: #{type.inspect}, #{token.inspect}"
            end

    [type, token]
  end

  # 終端記号をpush
  def push_terminal(type=nil, token=nil)
    unless type
      @current_type, @current_token = advance
    end

    _space = "".rjust(@indent, ' ')
    @elemtns.push("#{_space}<#{@current_type}> #{@current_token} </#{@current_type}>\r\n")
  end

  # 非終端記号をpush
  def begin_non_terminal(element)
    _space = "".rjust(@indent, ' ')
    @indent += 2
    @elemtns.push("#{_space}<#{element}>\r\n")
  end

  def end_non_terminal(element)
    @indent -= 2
    _space = "".rjust(@indent, ' ')
    @elemtns.push("#{_space}</#{element}>\r\n")
  end

  def match_next_token_type?(symbols, specific_token=nil)
    _token = @tokenizer.advance_at
    _type = @tokenizer.token_type(_token)
    # puts "@@@ next: #{_token}, #{_type}, #{specific_token}"

    if specific_token
      symbols.include?(_type) && specific_token == _token
    else
      symbols.include?(_type)
    end
  end

  def next_token_dot?
    @tokenizer.advance_at == "."
  end

  def next_token_brackets?
    @tokenizer.advance_at =~ /\(|\)/
  end

  def next_token_square_brackets?
    @tokenizer.advance_at =~ /\[|\]/
  end

  # search_token do |token|
  #   return true if token == ";"
  #   push_terminal
  # end

  # def search_token(token)
  #   loop do
  #     next unless yield token
  #   end
  # end
end
