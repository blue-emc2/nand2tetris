module CommonCodes

  # Aコマンドを実行
  def a_command(value)
    "@#{value}"
  end

  # Cコマンドを実行
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

  def goto(label)
    [
      a_command(label),
      c_command(comp: "0", jump: "JMP"),
    ]
  end

  def frame_to_register(src, offset, dest)
    [
      a_command(src),
      c_command(dest: "D", comp: "M"),
      a_command(offset),
      c_command(dest: "AD", comp: "D-A"),
      c_command(dest: "D", comp: "M"),
      a_command(dest),
      c_command(dest: "M", comp: "D")
    ]
  end

  def set_regster_to_regster(src, dest)
    [
      a_command(src),
      c_command(dest: "AD", comp: "M"),
      a_command(dest),
      c_command(dest: "M", comp: "D"),
    ]
  end

end
