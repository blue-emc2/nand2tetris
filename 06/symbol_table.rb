class SymbolTable

  attr_accessor :symbol_table

  def initialize
    @symbol_table = {
      "SP" => 0,
      "LCL" => 1,
      "ARG" => 2,
      "THIS" => 3,
      "THAT" => 4,
      "SCREEN" => 16384,
      "KBD" => 24576
    }

    (0..15).each do |i|
      @symbol_table["R#{i}"] = i.to_i
    end
  end

  def add_entry(symbol, address)
    @symbol_table[symbol] = address.to_i
  end

  def contains(symbol)
    @symbol_table.key?(symbol)
  end

  def get_address(symbol)
    @symbol_table[symbol]
  end

end
