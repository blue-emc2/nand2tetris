class ClassVarDec

  KEYWORDS = %w(static field boolean)

  def initialize
    @class_elements = []
  end

  def begin_tag
    @class_elements.push("<classVarDec>")
  end

  def end_tag
    @class_elements.push("</classVarDec>")
  end

  def create_jack_element(type, token)
    puts "create_class_element #{type}, #{token}"
    if type == :keyword && KEYWORDS.include?(token)
      terminal(type, token)
    elsif type == :identifier
      terminal(type, token)
    elsif type == :symbol
      terminal(type, token)
    else
      return false
    end

    true
  end

  def terminal(type, token)
    @class_elements.push("<#{type}> #{token} </#{type}>")
  end

  def dump
    @class_elements
  end
end
