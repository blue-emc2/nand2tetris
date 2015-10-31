class SymbolTable

  attr_accessor :symbol_table

  def initialize
    @symbol_table = {}
  end

  def add_entry(symbol, address)
    @symbol_table["symbol"] = address
  end

  def contains(symbol)
    @symbol_table.key?
  end

  def get_address(symbol)
    @symbol_table["symbol"]
  end

end
