require "./parser.rb"

# MEMO
# @SPはtestで256番地を指すようになっている
# 265  -91
# 266  82
# 267  112
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
      asms << "@SP"
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

    @jump_index += 1

    write_asm(asms)
  end

  def write_push_pop(command, segment, index)
    asms = []

    asms << "\/\/ -------- #{command} begin " if @debug

    # push: @SPが指すアドレスに値を格納して、SPの指すアドレスをインクリメントする
    if command == Parser::COMMANDS[:push]
      if "constant" == segment
        asms << "@#{index}"
        asms << "D=A"

        asms << load_sp
        asms << inc_sp
      end
    end

    asms << "\/\/ -------- #{command} end " if @debug

    write_asm(asms)
  end

  # スタックポインタのアドレスをインクリメント
  def inc_sp
    %w(@SP M=M+1)
  end

  def dec_sp
    %w(@SP M=M-1)
  end

  def load_sp
    [
      "@SP",
      "A=M",
      "M=D"
    ]
  end

  # x < y true それ以外はfalse
  def lt
    create_load_and_jump_codes("JLT")
  end

  # 引き算して結果をDに格納する。
  # 判定はJMP命令を利用する。
  # JUMP先はindexを付けて変な場所にJUMPしないようにする
  def eq
    create_load_and_jump_codes("JEQ")
  end

  # x > yであればtrue それ以外はfalse
  def gt
    create_load_and_jump_codes("JGT")
  end

  def sub
    [
      dec_sp,
      load_sp,
      dec_sp,
      "@SP",
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
      "@SP",
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
      "@SP",
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

  # いいメソッド名が思いつかないけど、処理をまとめたい
  # if x == y
  #   D = true
  # else
  #   D = false
  # end
  # みたいな事をしている
  def create_load_and_jump_codes(jmp)
    [
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
  end

  def write_asm(asms)
    asms.flatten.each do |asm|
      @writer.write("#{asm}\n")
    end
  end

  def close
    @writer.close
  end
end
