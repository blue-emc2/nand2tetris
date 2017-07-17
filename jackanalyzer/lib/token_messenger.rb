class TokenMessenger

  attr_accessor :position

  def initialize(tokens)
    @position = 0
    @space = 0
    @tokens = tokens
    @stack = []
  end

  def terminal
    # token = @tokens[@position]
    token = @tokens.shift

    "#{indent}#{token}"
  end

  # 非終端記号タグを出力する
  # 非終端記号タグを開く時にインデントを下げ、非終端記号タグを閉じる度インデントを上げる
  def non_terminal(token)
    token_exist = @stack.include?(token)

    if token_exist  # 既に非終端記号がある時は削除し、インデントを上げて閉じるタグを生成する
      @space -= 1
      tag = "#{indent}</#{token}>"
      @stack.delete(token)
    else
      tag = "#{indent}<#{token}>"
      @stack << token
      @space += 1
    end

    tag
  end

  def current_token
    token(@position)
  end

  def look_ahead_token
    token(@position + 1)
  end

  private

  def token(position)
    _a, token, _b = @tokens[position]&.split
    # puts "token: #{_a}, #{token}, #{_b}"
    return nil unless token
    token
  end

  def indent
    " " * (@space * 2)
  end
end
