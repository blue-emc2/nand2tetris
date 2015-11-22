require "./parser.rb"

# MEMO
# @SPはtstで256番地を指すようになっている
class CodeWriter

  attr_accessor :writer, :output_files, :stack

  def initialize(file)
    @writer = File.open(file, "w")
    @output_files = [file]
    @stack = 256
  end

  def set_file_name(file)
    @output_files << file
  end

  def write_arithmetic(command)
    asms = []

    if command == "add"
      # アドレスをさかのぼる
      asms << "@SP\n"
      asms << "M=M-1\n"

      # その時点で指しているアドレスの値をロードする
      asms << "@SP\n"
      asms << "A=M\n"
      asms << "D=M\n"

      asms << "@SP\n"
      asms << "M=M-1\n"
      asms << "@SP\n"
      asms << "A=M\n"
      asms << "D=D+M\n"
      asms << "M=D\n"

      # ＠SPには計算結果が格納済みなので先頭アドレスを変えておく
      asms << "@SP\n"
      asms << "M=M+1\n"
    end

    asms.each do |asm|
      @writer.write(asm)
    end
  end

  def write_push_pop(command, segment, index)
    asms = []

    # push: @SPが指すアドレスに値を格納して、SPの指すアドレスをインクリメントする
    if command == Parser::COMMANDS[:push]
      if "constant" == segment
        asms << "@#{index}\n"
        asms << "D=A\n"

        asms << "@SP\n"
        asms << "A=M\n" # @SP内にあるアドレスを取得
        asms << "M=D\n" # 取得したアドレスに値をロード

        # スタックポインタのアドレスをインクリメント
        asms << "@SP\n"
        asms << "M=M+1\n"
      end
    end

    asms.each do |asm|
      @writer.write(asm)
    end
  end

  def close
    @writer.close
  end
end
