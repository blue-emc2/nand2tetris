class Token

  attr_accessor :token, :terminal

  def initialize(text, terminal: true)
    @text = text

    if terminal
      @tag_start, @token, @tag_end = text.chomp.split 
    else
      @token = text.delete("/")
    end

    @terminal = terminal
  end

  def to_xml
    if @terminal
      "#{@tag_start} #{@token} #{@tag_end}"
    else
      "<#{@text}>"
    end
  end
end

