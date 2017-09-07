class SymbolTable

  def initialize
    @class_scope = {}
    @subroutine_scope = {}
  end

  def define(name, type, kind)
    v = Variable.new(name, type, kind)
    # TODO: kindをみてどちらかのハッシュかを判断する
    @class_scope[name] = v
  end

  def to_xml(name)
    v = @class_scope[name]
    <<~EOF
      <symbolTable>
        <name> #{v.name} </name>
        <category>  </category>
        <index> 0 </index>
        <scope>  </scope>
      </symbolTable>
    EOF
  end

end

class Variable

  attr_accessor :name, :type, :kind

  def initialize(name, type, kind)
    @name = name
    @type = type
    @kind = kind
  end

end


