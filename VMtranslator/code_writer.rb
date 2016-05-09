require "./VMtranslator/parser.rb"
require "./VMtranslator/common_codes.rb"

# MEMO
# M -> Memory[A]
#
class CodeWriter

  include CommonCodes

  TRUE = -1
  FALSE = 0

  SEGMENT_TO_REGISTER_MAP = {
    "sp" => "SP",
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
    @label_index = 0
  end

  def set_file_name(file)
    @output_files << file
  end

  # ブートストラップコード
  # SP=256
  # call Sys.init
  def write_init
    asms = [
      a_command("256"),
      c_command(dest: "D", comp: "A"),
      a_command("0"),
      c_command(dest: "M", comp: "D"),
      call("Sys.init")
    ]

    write_asm(asms)
  end

  def write_call(function_name, num_locals=0)
    asms = []
    asms << "\/\/ -------- begin write_call #{function_name}, #{num_locals} " if @debug
    asms += call(function_name, num_locals)
    write_asm(asms)
  end

  def call(function_name, num_locals=0)
    asms = []
    return_address = label_index
    # push return address
    asms += push_constant(return_address)

    asms += [
      push("local"),
      push("argument"),
      push("this"),
      push("that")
    ]

    # ARG = SP - n - 5
    offset = (-num_locals.to_i) - 5
    offset = offset.abs if offset < 0

    asms += [
      a_command(offset),
      c_command(dest: "D", comp: "A"),
      a_command(SEGMENT_TO_REGISTER_MAP["sp"]),
      c_command(dest: "D", comp: "M-D"),
      a_command(SEGMENT_TO_REGISTER_MAP["argument"]),
      c_command(dest: "M", comp: "D"),
    ]

    # LCL = SP
    asms += [
      a_command(SEGMENT_TO_REGISTER_MAP["sp"]),
      c_command(dest: "D", comp: "M"),
      a_command(SEGMENT_TO_REGISTER_MAP["local"]),
      c_command(dest: "M", comp: "D"),
    ]

    asms += [
      goto(function_name),
      new_label(return_address)
    ]
  end

  def push(segment)
    [
      a_command("0"),
      c_command(dest: "D", comp: "A"),
      a_command(SEGMENT_TO_REGISTER_MAP[segment]),
      c_command(dest: "AD", comp: "D+A"),
      c_command(dest: "D", comp: "M"),
      load_sp,
      inc_sp
    ]
  end

  # NOTE: returnする時のスタックの状態
  # function用引数アドレス開始位置
  # リターンアドレス
  # 保存されたLCL
  # 保存されたLCL
  # 保存されたARG
  # 保存されたTHIS
  # 保存されたTHAT
  # function内ローカル変数アドレス開始位置
  # function内SP
  def write_return
    asms = []
    asms << "\/\/ -------- return begin " if @debug

    # FRAME(R13) = LCL
    asms += set_regster_to_regster(SEGMENT_TO_REGISTER_MAP["local"], "R13")

    # RET = *(FRAME-5) リターンアドレスを取得
    asms += [
      a_command("5"),
      c_command(dest: "A", comp: "D-A"),
      c_command(dest: "D", comp: "M"),
      a_command("R14"),
      c_command(dest: "M", comp: "D")
    ]

    # *ARG = pop()  戻り値を設定
    asms += [
      dec_sp,
      a_command(SEGMENT_TO_REGISTER_MAP["argument"]),
      c_command(dest: "AD", comp: "M"),
      a_command("R15"),
      c_command(dest: "M", comp: "D"),
      a_command(SEGMENT_TO_REGISTER_MAP["sp"]),
      "A=M",
      "D=M",
      a_command("R15"),
      "A=M",
      "M=D",
      a_command(SEGMENT_TO_REGISTER_MAP["argument"]),
      c_command(dest: "D", comp: "M"),
    ]

    # SP = ARG + 1  呼び出し側のSPを戻す（アドレス計算）
    asms += [
      a_command("SP"),
      c_command(dest: "M", comp: "D+1"),
    ]

    # 呼び出し側のTHAT, THIS, ARG, LCLを戻す
    asms += frame_to_register("R13", "1", SEGMENT_TO_REGISTER_MAP["that"])
    asms += frame_to_register("R13", "2", SEGMENT_TO_REGISTER_MAP["this"])
    asms += frame_to_register("R13", "3", SEGMENT_TO_REGISTER_MAP["argument"])
    asms += frame_to_register("R13", "4", SEGMENT_TO_REGISTER_MAP["local"])

    # fanction return
    asms += [
      a_command("R14"),
      c_command(dest: "A", comp: "M"),
      c_command(comp: "0", jump: "JMP"),
    ]

    write_asm(asms)
  end

  # name: 関数名
  # num_locals: 関数内のローカル変数の個数
  def write_function(name, num_locals)
    asms = []
    asms << "\/\/ -------- function #{name} begin " if @debug

    asms << new_label(name) # 関数の開始位置とする為のラベル

    # 引数を初期化
    num_locals.to_i.times do |i|
      asms << push_constant(0)
    end

    write_asm(asms)
  end

  def write_label(label)
    asms = []
    asms << "\/\/ -------- #{label} begin " if @debug
    asms << new_label(label)

    write_asm(asms)
  end

  def write_if(label)
    asms = []
    asms << "\/\/ -------- #{label} begin " if @debug
    asms << if_goto(label)

    write_asm(asms)
  end

  def write_goto(label)
    asms = []
    asms << "\/\/ -------- #{label} begin " if @debug
    asms << goto(label)

    write_asm(asms)
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
      asms << add
    when :sub
      asms << sub
    when :eq
      asms << eq
    when :lt
      asms << lt
    when :gt
      asms << gt
    when :neg
      asms << unary_asm("-M")
    when :and
      asms << and_asm
    when :or
      asms << or_asm
    when :not
      asms << unary_asm("!M")
    else
      asms << nil
    end

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
        asms << push_constant(index)
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
      c_command(dest: "D", comp: "A"),
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

  def push_constant(value)
    [
      a_command(value),
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
    ] + set_stack_to_reg(temp_variable)
  end

  def pop_pointer(segment, index)
    base_address = "3"
    temp_variable = "R13"

    [
      a_command(index),
      c_command(dest: "D", comp: "A"),
      a_command(base_address),
      "AD=D+A",
      a_command(temp_variable),
      "M=D",
    ] + set_stack_to_reg(temp_variable)
  end

  # temp iは 5 + i 番目のアドレスへとアクセスする アセンブリコードへ変換
  def pop_temp(segment, index)
    base_address = "5"
    temp_variable = "R13"

    [
      a_command(index),
      c_command(dest: "D", comp: "A"),
      a_command(base_address),
      "AD=D+A",
      a_command(temp_variable),
      "M=D",
    ] + set_stack_to_reg(temp_variable)
  end

  def pop_mem_to_stack(segment, index)
    temp_variable = "R13"

    [
      a_command(index),
      c_command(dest: "D", comp: "A"),
      a_command(SEGMENT_TO_REGISTER_MAP[segment]),
      "A=M",
      "AD=D+A",       # AD = *(base_address + offset)
      a_command(temp_variable),  # 一時変数
      "M=D",          # base_address + offsetのアドレスを覚えておく
    ] + set_stack_to_reg(temp_variable)
  end

  def set_stack_to_reg(register)
    [
      dec_sp,
      a_command("SP"),
      "A=M",    # A = A[0]
      "D=M",    # D = A[256]
      a_command(register),
      "A=M",    # A = A[@R13]
      "M=D"     # A[3] = D
    ]
  end

  # 最上位stackから値を取得し、引数のレジスタに値を格納
  def pop_stack_to_reg(register)
    [
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=M",
      a_command(register),
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

  def add
    [
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=M",
      dec_sp,
      a_command("SP"),
      "A=M",
      "D=D+M",
      load_sp,
    ]
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

  # 単項式を出力するアセンブラ
  def unary_asm(operator_comp)
    [
      dec_sp,
      load_sp,
      "D=#{operator_comp}",
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
      c_command(comp: "0", jump: "JMP"),

      "(RESULT_TRUE_#{@jump_index})",
      "D=#{TRUE}",
      "@END_#{@jump_index}",
      c_command(comp: "0", jump: "JMP"),

      "(RESULT_FALSE_#{@jump_index})",
      "D=#{FALSE}",
      "@END_#{@jump_index}",
      c_command(comp: "0", jump: "JMP"),

      "(END_#{@jump_index})",
      load_sp
    ]

    @jump_index += 1
    asm
  end

  # TODO: いちいち呼ぶ必要ない
  def write_asm(asms)
    asms.flatten.each do |asm|
      @writer.write("#{asm}\n")
    end
  end

  def close
    @writer.close
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

  private

  def label_index
    _label = "label_#{@label_index}"
    @label_index += 1
    _label
  end

end
