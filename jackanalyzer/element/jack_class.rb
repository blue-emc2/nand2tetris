class JackClass

  KEYWORD = "class"
  SYMBOLS = %w({ })
  ARROW_LIST = [KEYWORD] + SYMBOLS

  def initialize
    @class_elements = []
  end

  def begin_tag
    @class_elements.push("<class>")
  end

  def end_tag
    @class_elements.push("</class>")
  end

  def create_class_element(type, token)
    # puts "create_class_element #{type}, #{type.class}, #{token}"
    if type == :keyword && KEYWORD == token
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
