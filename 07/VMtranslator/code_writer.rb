require "./parser.rb"

# MEMO
# @SPはtstで256番地を指すようになっている
class CodeWriter

  attr_accessor :writer, :output_files, :stack

  def initialize(file)
    @writer = File.open(file, "w")
    @output_files = [file]
  end

  def set_file_name(file)
    @output_files << file
  end

  def write_arithmetic(command)
    asms = []

    case command
    when "add"
      asms << dec_sp
      asms << load_sp # Mにロード
      asms << dec_sp
      asms << "@SP"
      asms << "A=M"
      asms << "D=D+M"
      asms << "M=D"

      # ＠SPには計算結果が格納済みなので先頭アドレスを変えておく
      asms << inc_sp
    when "eq"
    else
      asms << ""
    end

    write_asm(asms)
  end

  def write_push_pop(command, segment, index)
    asms = []

    # push: @SPが指すアドレスに値を格納して、SPの指すアドレスをインクリメントする
    if command == Parser::COMMANDS[:push]
      if "constant" == segment
        asms << "@#{index}"
        asms << "D=A"

        asms << load_sp
        asms << inc_sp
      end
    end

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
      "A=M",  # @SP内にあるアドレスを取得
      "M=D"   # 取得したアドレスに値をロード
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
