class Row

  attr_accessor :text

  def initialize(text)
    @text = text.chomp
  end

  def skip_line?
    @text.gsub(" ", "").empty? || comment?
  end

  private

  def comment?
    @text.include?('//')
  end

end
