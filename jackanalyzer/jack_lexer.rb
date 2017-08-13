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
end
