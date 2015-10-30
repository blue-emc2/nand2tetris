class Code

  def self.dest(code)
    puts "#{__method__}: #{code}"

    d1, d2, d3 = "0", "0", "0"
    return d1 + d2 + d3 if code.nil?

    raise "Don't know code: #{code}" unless code =~ /A|D|M/

    if code.to_s.include?("A")
      d1 = "1"
    end

    if code.to_s.include?("D")
      d2 = "1"
    end

    if code.to_s.include?("M")
      d3 = "1"
    end

    d1 + d2 + d3
  end

  def self.jump(code)
    return "000" if code.nil?
  end

  def self.comp(code)
    if code.include?("M")
      a = "1"
      _comp = convert_a_one(code)
    else
      a = "0"
      _comp = convert_a_zero(code)
    end

    puts "#{__method__}: #{code}, #{a}, #{_comp}"

    a << _comp
  end

  def self.convert_a_zero(code)
    c = ""
    if code =~ /\d+/
      c = case code.to_i
          when 0
            "101010"
          when 1
            "111111"
          when -1
            "111010"
          else
            raise "Don't know code: #{code}"
          end

    else
      count = code.split("").size

      if count == 3
        c = case code.to_s
            when "D+1"
              "011111"
            when "A+1"
              "110111"
            when "D-1"
              "001110"
            when "A-1"
              "110010"
            when "D+A"
              "000010"
            when "D-A"
              "010011"
            when "A-D"
              "000111"
            when "D&A"
              "000000"
            when "D|A"
              "010101"
            else
              raise "Don't know code: #{code}"
            end
      elsif count == 2
        c = case code.to_s
            when "!D"
              "001100"
            when "-D"
              "001111"
            when "!A"
              "110001"
            when "-A"
              "110011"
            else
              raise "Don't know code: #{code}"
            end
      elsif count == 1
        c = case code.to_s
            when "D"
              "001100"
            when "A"
              "110000"
            else
              raise "Don't know code: #{code}"
            end
      end
    end

    c
  end

  def self.convert_a_one(code)
    c = case code.to_s
        when "M"
          "110000"
        when "!M"
          "110001"
        when "-M"
          "110011"
        when "M+1"
          "110111"
        when "M-1"
          "110010"
        when "D+M"
          "000010"
        when "D-M"
          "010011"
        when "M-D"
          "010011"
        when "M&D"
          "000000"
        when "D|M"
          "010101"
        else
          raise "Don't know code: #{code}"
        end
  end

end
