require "./VMtranslator/parser.rb"

# MEMO
# M -> Memory[A]
#
class CodeWriter

  TRUE = -1
  FALSE = 0

  SEGMENT_TO_REGISTER_MAP = {
    "local" => "LCL",
    "argument" => "ARG",
    "this" => "THIS",
    "that" => "THAT",
  }.freeze

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

  def write_label(label)
    asms = []
    asms << "\/\/ -------- #{label} begin " if @debug
    asms << new_label(label)
    asms << "\/\/ -------- #{label} end " if @debug

    write_asm(asms)
  end

  def write_if(label)
    asms = []
    asms << "\/\/ -------- #{label} begin " if @debug
    asms << if_goto(label)
    asms << "\/\/ -------- #{label} end " if @debug

    write_asm(asms)
  end

  def write_goto(label)
    asms = []
    asms << "\/\/ -------- #{label} begin " if @debug
    asms << goto(label)
    asms << "\/\/ -------- #{label} end " if @debug

    write_asm(asms)
  end

  def goto(label)
    [
      a_command(label),
      c_command(comp: "0", jump: "JMP"),
    ]
  end

  # スタックの最上位の値をポップし、
  # その値が0でなければ、xxxでラベル付けされた場所からプログラムの実行を開始する。
  # そうでなければ、プログラムの次のコマンドが実行される。
  def if_goto(label)
    asms = pop_stack_to_reg("R13")

    asms += [
      "D=M",
      a_command(label),
      c_command(comp: "D", jump: "JNE"),    # if D != 0 jump
      a_command("#{label}_END"),
      c_command(comp: "0", jump: "JMP"),
      new_label("#{label}_END"),
    ]

    asms
  end

  def write_arithmetic(command)
    asms = []

    asms << "\/\/ -------- #{command} begin " if @debug

    case command
    when :add
      asms << dec_sp
      asms << load_sp # Mにロード
      asms << dec_sp
      asms << a_command("SP")
      asms << "A=M"
      asms << "D=D+M"
      asms << "M=D"

    when :sub
      asms << sub
    when :eq
      asms << eq
    when :lt
      asms << lt
    when :gt
      asms << gt
    when :neg
      asms << neg
    when :and
      asms << and_asm
    when :or
      asms << or_asm
    when :not
      asms << not_asm
    else
      asms << nil
    end

    asms << "\/\/ -------- #{command} end " if @debug

    asms << inc_sp

    write_asm(asms)
  end

  # vmコマンド
  # push segment index
  #   segment[index]をスタック上にpush
  # pop segment index
  #   スタックの一番上のデータをpopし、それをsegment[index]に格納
  def write_push_pop(command, segment, index)
    asms = []

    asms << "\/\/ -------- #{command}, #{segment}, #{index} begin " if @debug

    # push: @SPが指すアドレスに値を格納して、SPの指すアドレスをインクリメントする
    if command == Parser::COMMANDS[:push]
      case segment
      when "constant"
        asms << push_constant(segment, index)
      when "local", "that", "argument", "this"
        asms << push_mem_to_stack(segment, index)
      when "temp"
        asms << push_temp(segment, index)
      when "pointer"
        asms << push_pointer(segment, index)
      when "static"
        asms << push_static(segment, index)
      end
    end

    if command == Parser::COMMANDS[:pop]
      case segment
      when "argument", "this", "that", "local"
        asms << pop_mem_to_stack(segment, index)
      when "temp"
        asms << pop_temp(segment, index)
      when "pointer"
        asms << pop_pointer(segment, index)
      when "static"
        asms << pop_static(segment, index)
      end
    end

    asms << "\/\/ -------- #{command} end " if @debug

    write_asm(asms)
  end

  # base address => 16
  def push_static(segment, index)
    base_address = "16"

    [
      "D=0",
      a_command(base_address.to_i + index.to_i),
      "AD=D+A",
      "D=M",
      load_sp,
      inc_sp
    ]
  end

  def push_temp(segment, index)
    base_address = "5"

    [
      a_command(index),
      c_command("D", "A"),
      a_command(base_address),
      "AD=D+A",
      "D=M",
      load_sp,
      inc_sp
    ]
  end

  # RAM上にマッピングされている、レジスタ（local、argument、this、that）をStackにpushするアセンブラコードを出力する
  # RAM内の(base + i)番目のアドレスへアクセスするアセンブリコード
  def push_mem_to_stack(segment, index)
    [
      a_command(index),
      c_command(dest: "D", comp: "A"),
      a_command(SEGMENT_TO_REGISTER_MAP[segment]),
      "A=M",    # A=M[LCL,ARG,THIS,THAT]
      "AD=D+A",
      "D=M",
      load_sp,
      inc_sp
    ]
  end

  def push_constant(segment, index)
    [
      a_command(index),
      "D=A",
      load_sp,
      inc_sp
    ]
  end

  def push_pointer(segment, index)
    base_address = "3"

    [
      a_command(index),         # offset
      c_command(dest: "D", comp: "A"),
      a_command(base_address),  # base address
      c_command(dest: "AD", comp: "D+A"),   # *(base_address + offset)
      c_command(dest: "D", comp: "M"),
      load_sp,  # pointerが指す値をstackに格納
      inc_sp
    ]
  end

  def pop_static(segment, index)
    base_address = 16
    temp_register = "R13"

    [
      "D=0",
      a_command(base_address + index.to_i),
      "AD=D+A",
      a_command(temp_register),
      "M=D",
      dec_sp,
    ] + set_stack_to_reg(temp_variable)
  end

  def pop_pointer(segment, index)
    base_address = "3"
    temp_variable = "@R13"

    [
      a_command(index),
      c_command(dest: "D", comp: "A"),
      a_command(base_address),
      "AD=D+A",
      temp_variable,
      "M=D",
      dec_sp,
    ] + set_stack_to_reg(temp_variable)
  end

  # temp iは 5 + i 番目のアドレスへとアクセスする アセンブリコードへ変換
  def pop_temp(segment, index)
    base_address = "5"
    temp_variable = "@R13"

    [
      a_command(index),
      c_command(dest: "D", comp: "A"),
      a_command(base_address),
      "AD=D+A",
      temp_variable,
      "M=D",
      dec_sp,
    ] + set_stack_to_reg(temp_variable)
  end

  def pop_mem_to_stack(segment, index)
    temp_variable = "@R13"

    [
      a_command(index),
      c_command(dest: "D", comp: "A"),
      a_command(SEGMENT_TO_REGISTER_MAP[segment]),
      "A=M",
      "AD=D+A",       # AD = *(base_address + offset)
      temp_variable,  # 一時変数
      "M=D",          # base_address + offsetのアドレスを覚えておく
      dec_sp,
    ] + set_stack_to_reg(temp_variable)
  end

  def set_stack_to_reg(register)
    [
      a_command("SP"),
      "A=M",    # A = A[0]
      "D=M",    # D = A[256]
      register,
      "A=M",    # A = A[@R13]
      "M=D"     # A[3] = D
    ]
  end

  def pop_stack_to_reg(reg)
    [
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=M",
      a_command(reg),
      "M=D"
    ]
  end

  # スタックポインタのアドレスをインクリメント
  def inc_sp
    [
      a_command("SP"),
      c_command(dest: "M", comp: "M+1")
    ]
  end

  # スタックポインタのアドレスをデクリメント
  def dec_sp
    [
      a_command("SP"),
      c_command(dest: "M", comp: "M-1")
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
      c_command("0", "JMP"),

      "(RESULT_TRUE_#{@jump_index})",
      "D=#{TRUE}",
      "@END_#{@jump_index}",
      c_command("0", "JMP"),

      "(RESULT_FALSE_#{@jump_index})",
      "D=#{FALSE}",
      "@END_#{@jump_index}",
      c_command("0", "JMP"),

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

  # havivhaさんのを参考にした
  # dest：保存先を決定するregister
  # comp：計算用のasm
  # jump：ジャンプ命令
  def c_command(dest: nil, comp: nil, jump: nil)
    if jump
      "#{comp};#{jump}"
    else
      "#{dest}=#{comp}"
    end
  end

  def new_label(label)
    "(#{label})"
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
