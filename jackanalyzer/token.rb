class Token

  attr_accessor :terminal, :token

  def initialize(text, _terminal=true, options={})
    @tag_start, @token, @tag_end = text.split
    @terminal = _terminal
  end

  def to_markup
    "#{@tag_start} #{@token} #{@tag_end}"
  end
end

