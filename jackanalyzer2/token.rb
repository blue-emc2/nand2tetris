class Token

  attr_accessor :token, :terminal, :text

  def initialize(text, terminal: true)
    @text = text

    if terminal
      # xml形式のtextを要素と内容に分解する
      @tag_start, @token, @tag_end = text.chomp.split(%r((<.+>)(.+)(<\/.+>))).reject(&:empty?).map(&:strip)
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

