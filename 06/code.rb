class Code

  def self.dest(code)
    d1, d2, d3 = %w(0 0 0)
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

    puts "#{__method__}: #{code}, #{d1},#{d2},#{d3}"

    d1 + d2 + d3
  end

  def self.jump(code)
    # わざわざ分割する必要ないか

    j1, j2, j3 = %w(0 0 0)
    return j1 + j2 + j3 if code.nil?

    j1, j2, j3 = case code.to_s
                  when "JGT"
                    %w(0 0 1)
                  when "JEQ"
                    %w(0 1 0)
                  when "JGE"
                    %w(0 1 1)
                  when "JLT"
                    %w(1 0 0)
                  when "JNE"
                    %w(1 0 1)
                  when "JLE"
                    %w(1 1 0)
                  when "JMP"
                    %w(1 1 1)
                  end

    puts "#{__method__}: #{code}, #{j1}, #{j2}, #{j3}"

    j1 + j2 + j3
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
    count = code.split("").size

    puts "#{__method__}: #{count}"

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
          when "-1"
            "111010"
          else
            raise "Don't know code: #{code}"
          end
    elsif count == 1
      c = case code.to_s
          when "D"
            "001100"
          when "A"
            "110000"
          when "0"
            "101010"
          when "1"
            "111111"
          else
            raise "Don't know code: #{code}"
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
          "000111"
        when "D&M"
          "000000"
        when "D|M"
          "010101"
        else
          raise "Don't know code: #{code}"
        end
  end

end
