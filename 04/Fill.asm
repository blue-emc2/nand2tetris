// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// if kbd = 0 then state = 0
// else state = 1

  @state
  M=0
(KBDLOOP)
  @KBD
  D=M
  @STATEZERO  // ジャンプ先を定義
  D;JEQ       // 0であればstateを0にする
  @STATENEGATIVEONE
  D;JNE       // 0以外であれば-1にする

(STATEZERO)   // state塗りつぶさない
  @state
  M=0
  @SCREENLOOP
  0;JMP

(STATENEGATIVEONE)  // stateに-1を入れて塗りつぶす
  @state
  M=-1
  @SCREENLOOP
  0;JMP

(SCREENLOOP)
  @counter  // ループカウンタ
  M=0
  @8193     // 終了条件
  D=A
  @counter
  M=D
  @i
  M=0
  @SCREEN
  D=A
  @screen_position
  M=D
(LOOP)
  @counter
  M=M-1     // counter -= 1
  D=M
  @END      // 描画し終わったらループ脱出
  D;JEQ

  @i
  D=M       // offsetをDレジスタへロード
  @screen_position
  M=D+M     // 描画位置(16384 + offset番地)を退避

  @state
  D=M       // 1111 1111 1111 1111

  @screen_position
  A=M       // 点描画
  M=D

  @i
  M=1     // i += 1
  @LOOP
  0;JMP
(END)
  @KBDEND
  0;JMP

(KBDEND)
  @KBDLOOP  // 始めに戻る
  0;JMP
