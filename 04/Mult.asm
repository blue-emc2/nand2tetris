// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
// A データとアドレス、データメモリへ直接アクセスする、
// D データ値だけ扱う
// M レジスタではない、M が参照するメモリのワードは、現在の A レジスタの値をアドレ スとするメモリワードの値である
// D=Memory[516]-1をする時はAレジスタに516を設定してからD=M-1をする
  @2    // sum
  M=0   // sum=0
  @i    // i
  M=0   // i=0
(LOOP)
  @1    // R1
  D=M   // D=R1
  @END
  D;JEQ // if r1>0

  @0    // R0
  D=M   // D=i
  @2    // sum
  M=D+M // sum=sum+i
  @1    // R1
  M=M-1
  @LOOP
  0;JMP
(END)
  @END
  0;JMP
