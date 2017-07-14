class TokenMessenger

  def initialize(tokens)
    @current_line_pos = 0
    @space = 0
    @tokens = tokens
    @stack = []
  end

  def terminal
    token = @tokens[@current_line_pos]
    @current_line_pos += 1

    "#{indent}#{token}"
  end

  # 非終端記号タグを出力する
  # 非終端記号タグを開く時にインデントを下げ、非終端記号タグを閉じる度インデントを上げる
  def non_terminal(token)
    token_exist = @stack.include?(token)

    if token_exist  # 既に非終端記号がある時は削除し、インデントを上げて閉じるタグを生成する
      tag = "#{indent}</#{token}>"
      @space -= 1
      @stack.delete(token)
    else
      tag = "#{indent}<#{token}>"
      @stack << token
      @space += 1
    end

    tag
  end

  def current_token
    token(@current_line_pos)
  end

  def look_ahead_token
    token(@current_line_pos + 1)
  end

  def token(position)
    _a, token, _b = @tokens[position]&.split

    return nil unless token
    token
  end

  def indent
    " " * (@space * 2)
  end
end
