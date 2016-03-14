require "./parser.rb"

# MEMO
# M -> Memory[A]
#
class CodeWriter

  TRUE = -1
  FALSE = 0

  attr_accessor :writer, :output_files

  def initialize(file)
    @writer = File.open(file, "w")
    @output_files = [file]
    @debug = true
    @jump_index = 0
  end

  def set_file_name(file)
    @output_files << file
  end

  def write_arithmetic(command)
    asms = []

    asms << "\/\/ -------- #{command} begin " if @debug

    case command
    when "add"
      asms << dec_sp
      asms << load_sp # Mにロード
      asms << dec_sp
      asms << a_command("SP")
      asms << "A=M"
      asms << "D=D+M"
      asms << "M=D"

    when "sub"
      asms << sub
    when "eq"
      asms << eq
    when "lt"
      asms << lt
    when "gt"
      asms << gt
    when "neg"
      asms << neg
    when "and"
      asms << and_asm
    when "or"
      asms << or_asm
    when "not"
      asms << not_asm
    else
      asms << ""
    end

    asms << "\/\/ -------- #{command} end " if @debug

    # ＠SPには計算結果が格納済みなので上書きしない為にずらしておく
    asms << inc_sp

    write_asm(asms)
  end

  def write_push_pop(command, segment, index)
    asms = []

    asms << "\/\/ -------- #{command}, #{segment}, #{index} begin " if @debug

    # push: @SPが指すアドレスに値を格納して、SPの指すアドレスをインクリメントする
    if command == Parser::COMMANDS[:push]
      case segment
      when "constant"
        asms << "@#{index}"
        asms << "D=A"

        asms << load_sp
        asms << inc_sp
      when "local"
        asms << push_local(segment, index)
      when "that"
        asms << push_that(segment, index)
      when "argument"
        asms << push_argument(segment, index)
      when "this"
        asms << push_this(segment, index)
      when "temp"
        asms << push_temp(segment, index)
      end
    end

    if command == Parser::COMMANDS[:pop]
      case segment
      when "local"
        asms << pop_local(segment)
      when "argument"
        asms << pop_argument(segment, index)
      when "this"
        asms << pop_this(segment, index)
      when "that"
        asms << pop_that(segment, index)
      when "temp"
        asms << pop_temp(segment, index)
      end
    end

    asms << "\/\/ -------- #{command} end " if @debug

    write_asm(asms)
  end

  def push_temp(segment, index)
    base_address = "5"

    [
      a_command(index),
      "D=A",
      a_command(base_address),
      "AD=D+A",
      "D=M",
      load_sp,
      inc_sp
    ]
  end

  def push_this(segment, index)
    [
      a_command(index),
      "D=A",
      a_command("THIS"),
      "A=M",
      "AD=D+A",
      "D=M",
      load_sp,
      inc_sp
    ]
  end

  def push_argument(segment, index)
    [
      a_command(index),
      "D=A",
      a_command("ARG"),
      "A=M",
      "AD=D+A",
      "D=M",
      load_sp,
      inc_sp
    ]
  end

  def push_that(segment, index)
    [
      a_command(index),
      "D=A",
      a_command("THAT"),
      "A=M",
      "AD=D+A",
      "D=M",
      load_sp,
      inc_sp
    ]
  end

  # RAM内の(base + i)番目のアドレスへアクセスするアセンブリコードへ変換
  def push_local(segment, index)
    [
      a_command(index),
      "D=A",
      a_command("LCL"),
      "A=M",  # A=M[@1]
      "AD=D+A",
      "D=M",
      load_sp,
      inc_sp
    ]
  end

  # temp iは 5 + i 番目のアドレスへとアクセスする アセンブリコードへ変換
  def pop_temp(segment, index)
    base_address = "5"
    temp_variable = "@R13"

    [
      a_command(index),
      "D=A",
      a_command(base_address),
      # "A=M",
      "AD=D+A",
      temp_variable,
      "M=D",
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=M",
      temp_variable,
      "A=M",
      "M=D"
    ]
  end

  def pop_that(segment, index)
    temp_variable = "@R13"

    [
      a_command(index),
      "D=A",
      a_command("THAT"),
      "A=M",
      "AD=D+A",
      temp_variable,
      "M=D",
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=M",
      temp_variable,
      "A=M",
      # "M=A",
      "M=D"
    ]
  end

  def pop_this(segment, index)
    temp_variable = "@R13"

    [
      a_command(index),
      "D=A",
      a_command("THIS"),
      "A=M",
      "AD=D+A",
      temp_variable,
      "M=D",
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=M",
      temp_variable,
      "A=M",
      # "M=A",
      "M=D"
    ]
  end

  # spの一番上に積んである値をポップし、segment[index]に格納する
  def pop_argument(segment, index)
    temp_variable = "@R13"

    [
      a_command(index),
      "D=A",
      a_command("ARG"),
      "A=M",
      "AD=D+A",
      temp_variable,
      "M=D",
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=M",
      temp_variable,
      "A=M",
      # "M=A", なくてもいい感じ
      "M=D"
    ]
  end

  # spの一番上に積んである値をlocalにpopする
  def pop_local(segment)
    [
      dec_sp,
      load_sp,
      load_lcl
    ]
  end

  # スタックポインタのアドレスをインクリメント
  def inc_sp
    [
      a_command("SP"),
      "M=M+1"
    ]
  end

  # スタックポインタのアドレスをデクリメント
  def dec_sp
    [
      a_command("SP"),
      "M=M-1"
    ]
  end

  # x < y true それ以外はfalse
  def lt
    compare("JLT")
  end

  # 引き算して結果をDに格納する。
  # 判定はJMP命令を利用する。
  # JUMP先はindexを付けて変な場所にJUMPしないようにする
  def eq
    compare("JEQ")
  end

  # x > yであればtrue それ以外はfalse
  def gt
    compare("JGT")
  end

  def sub
    [
      dec_sp,
      load_sp,
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=M-D",
      load_sp,
    ]
  end

  # if A & B(And演算)
  def and_asm
    [
      dec_sp,
      load_sp,
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=D&M",
      load_sp
    ]
  end

  # if A | B
  def or_asm
    [
      dec_sp,
      load_sp,
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=D|M",
      load_sp
    ]
  end

  def not_asm
    [
      dec_sp,
      load_sp,
      "D=!M",
      load_sp
    ]
  end

  def neg
    [
      dec_sp,
      load_sp,
      "D=-M",
      load_sp
    ]
  end

  # 比較処理
  # if x == y
  #   D = true
  # else
  #   D = false
  # end
  def compare(jmp)
    asm = [
      dec_sp,
      load_sp,
      dec_sp,
      "A=M",
      "D=M-D",
      "@RESULT_TRUE_#{@jump_index}",
      "D;#{jmp}",
      "@RESULT_FALSE_#{@jump_index}",
      "0;JMP",

      "(RESULT_TRUE_#{@jump_index})",
      "D=#{TRUE}",
      "@END_#{@jump_index}",
      "0;JMP",

      "(RESULT_FALSE_#{@jump_index})",
      "D=#{FALSE}",
      "@END_#{@jump_index}",
      "0;JMP",

      "(END_#{@jump_index})",
      load_sp
    ]

    @jump_index += 1
    asm
  end

  def write_asm(asms)
    asms.flatten.each do |asm|
      @writer.write("#{asm}\n")
    end
  end

  def close
    @writer.close
  end

  # 特定の値をAレジスタに格納
  def a_command(value)
    "@#{value}"
  end

  def self.define_load_asm(segment)
    define_method("load_#{segment}") do
      %W(@#{segment.swapcase}
        A=M
        M=D)
    end
  end

  define_load_asm "sp"
  define_load_asm "lcl"
  define_load_asm "argument"

end
