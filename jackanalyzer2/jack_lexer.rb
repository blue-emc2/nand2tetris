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
    @current_token = get_token(@p)
  end

  def next_token
    np = @p + 1
    get_token(np)
  end

  private

  def get_token(position)
    if @tokens[position].nil?
      Token.new(EOF)
    else
      Token.new(@tokens[position])
    end
  end 
end
