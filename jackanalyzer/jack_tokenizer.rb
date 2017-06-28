#
# 入力ストリームからすべてのコメントと空白文字を取り除き、Jack 文法に従い Jack 言語のトークンへ分割する
# 字句解析器
# 見通しが悪くなってきたら字句解析の部分だけでも外に出していいかも
#

require_relative 'jackanalyzer/jack_constants'

class JackTokenizer

  include JackConstants

  attr_accessor :current_token, :position

  def initialize(jack_file)
    @tokens = []
    @debug = true
    @symbol_regexp = Regexp.union(SYMBOLS.map{|symbol| Regexp.compile("(#{Regexp.escape(symbol)})")})   # /({)/の配列を作成している
    @position = 0
    open(jack_file)
  end

  def open(jack_file)
    lines = remove_comments(File.open(jack_file).read)

    lines.split("\r\n").each do |line|
      _line = line.strip
      @tokens += lexical_analysis(_line)  # 字句解析
    end
    @tokens.flatten!
  end

  def remove_comments(file)
    f = file.gsub(%r(//.+|/\*.+\*/|/\*\*.+\*/), "")
    f.gsub(Regexp.new("/\\*\\*.+?\\*/", Regexp::MULTILINE), "")
  end

  def has_more_commands?
    !@tokens.empty?
  end

  def advance
    @current_token = @tokens.at(@position)
    @position += 1
  end

  def advance_at(index)
    @tokens.at(index)
  end

  def token_type(token=nil)
    unless token
      token = @current_token
    end

    if token =~ /\A\".+\"\Z/
      :stringConstant
    elsif token =~ /\A\d+/
      :integerConstant
    elsif SYMBOLS.include?(token)
      :symbol
    elsif KEYWORDS.include?(token)
      :keyword
    elsif token =~ /\w/
      :identifier
    else
      puts "--- #{token.inspect}"
      "error"
    end
  end

  def symbol
    case @current_token
    when "<"
      "&lt;"
    when ">"
      "&gt;"
    when "&"
      "&amp;"
    else
      @current_token
    end
  end

  def keyword
    @current_token
  end

  def string_val
    @current_token.gsub("\"", "")
  end

  def int_val
    @current_token
  end

  def identifier
    @current_token
  end

  def lexical_analysis(line)
    _tokens = line.split(@symbol_regexp)

    if KEYWORDS.any?{|keyword| line.include?(keyword)}
      _tokens = _tokens.map {|token| token.include?("\"") ? token : token.split }
    end
    _tokens.compact.delete_if(&:empty?)
  end
end
