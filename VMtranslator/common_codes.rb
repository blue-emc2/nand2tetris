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

end
