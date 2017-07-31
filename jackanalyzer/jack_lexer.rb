# 言語実装パターンの実装を参考にした

class JackLexer
  include JackConstants

  EOF = "eof"

  attr_accessor :current_token

  def initialize(tokens)
    @tokens = tokens.delete_if {|t| t.include?("token")}
    @current_token = Token.new(@tokens.first)
    @p = 0
  end

  def advance
    @p += 1
    if @tokens[@p].nil?
      @current_token = Token.new(EOF)
    else
      @current_token = Token.new(@tokens[@p])
    end
  end

#  def match?(text)
#    puts "match?: #{@current_token == token}, look_ahead_token : #{get_token_from_look_ahead_token}, text : #{text}"
#    if get_text_from_look_ahead_token == text
#      advance
#      return true
#    else
#      raise SyntaxError, "expecting #{text.inspect}; found #{@current_token.inspect}"
#    end
#  end

end
