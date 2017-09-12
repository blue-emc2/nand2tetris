class SymbolTable

  NONE = "none"

  def initialize
    @class_scope = {}
    @subroutine_scope = {}
  end

  def define(name, type, kind)
    v = Variable.new(name, type, kind)
    # TODO: kindをみてどちらかのハッシュかを判断する
    @class_scope[name] = v
  end

  def kind_of(name)
    k = scope(name)&.kind
    k.nil? ? NONE : k


    if @class_scope.has_key?(name)
      @class_scope[name].kind
    elsif @subroutine_scope.has_key?(name)
      @subroutine_scope[name].kind
    else
      NONE
    end
  end

  def type_of(name)
    scope(name)&.type
  end

  def index_of(name)
    scope(name)&.index
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
