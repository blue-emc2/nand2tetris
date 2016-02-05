// -------- C_PUSH begin 
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- eq begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_0
D;JEQ
@RESULT_FALSE_0
0;JMP
(RESULT_TRUE_0)
D=-1
@END_0
0;JMP
(RESULT_FALSE_0)
D=0
@END_0
0;JMP
(END_0)
@SP
A=M
M=D
// -------- eq end 
@SP
M=M+1
// -------- C_PUSH begin 
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@16
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- eq begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_1
D;JEQ
@RESULT_FALSE_1
0;JMP
(RESULT_TRUE_1)
D=-1
@END_1
0;JMP
(RESULT_FALSE_1)
D=0
@END_1
0;JMP
(END_1)
@SP
A=M
M=D
// -------- eq end 
@SP
M=M+1
// -------- C_PUSH begin 
@16
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- eq begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_2
D;JEQ
@RESULT_FALSE_2
0;JMP
(RESULT_TRUE_2)
D=-1
@END_2
0;JMP
(RESULT_FALSE_2)
D=0
@END_2
0;JMP
(END_2)
@SP
A=M
M=D
// -------- eq end 
@SP
M=M+1
// -------- C_PUSH begin 
@892
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- lt begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_3
D;JLT
@RESULT_FALSE_3
0;JMP
(RESULT_TRUE_3)
D=-1
@END_3
0;JMP
(RESULT_FALSE_3)
D=0
@END_3
0;JMP
(END_3)
@SP
A=M
M=D
// -------- lt end 
@SP
M=M+1
// -------- C_PUSH begin 
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@892
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- lt begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_4
D;JLT
@RESULT_FALSE_4
0;JMP
(RESULT_TRUE_4)
D=-1
@END_4
0;JMP
(RESULT_FALSE_4)
D=0
@END_4
0;JMP
(END_4)
@SP
A=M
M=D
// -------- lt end 
@SP
M=M+1
// -------- C_PUSH begin 
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- lt begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_5
D;JLT
@RESULT_FALSE_5
0;JMP
(RESULT_TRUE_5)
D=-1
@END_5
0;JMP
(RESULT_FALSE_5)
D=0
@END_5
0;JMP
(END_5)
@SP
A=M
M=D
// -------- lt end 
@SP
M=M+1
// -------- C_PUSH begin 
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- gt begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_6
D;JGT
@RESULT_FALSE_6
0;JMP
(RESULT_TRUE_6)
D=-1
@END_6
0;JMP
(RESULT_FALSE_6)
D=0
@END_6
0;JMP
(END_6)
@SP
A=M
M=D
// -------- gt end 
@SP
M=M+1
// -------- C_PUSH begin 
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- gt begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_7
D;JGT
@RESULT_FALSE_7
0;JMP
(RESULT_TRUE_7)
D=-1
@END_7
0;JMP
(RESULT_FALSE_7)
D=0
@END_7
0;JMP
(END_7)
@SP
A=M
M=D
// -------- gt end 
@SP
M=M+1
// -------- C_PUSH begin 
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- gt begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
A=M
D=M-D
@RESULT_TRUE_8
D;JGT
@RESULT_FALSE_8
0;JMP
(RESULT_TRUE_8)
D=-1
@END_8
0;JMP
(RESULT_FALSE_8)
D=0
@END_8
0;JMP
(END_8)
@SP
A=M
M=D
// -------- gt end 
@SP
M=M+1
// -------- C_PUSH begin 
@57
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@31
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH begin 
@53
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- add begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
@SP
A=M
D=D+M
M=D
// -------- add end 
@SP
M=M+1
// -------- C_PUSH begin 
@112
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- sub begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
@SP
A=M
D=M-D
@SP
A=M
M=D
// -------- sub end 
@SP
M=M+1
// -------- neg begin 
@SP
M=M-1
@SP
A=M
M=D
D=-M
@SP
A=M
M=D
// -------- neg end 
@SP
M=M+1
// -------- and begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
@SP
A=M
D=D&M
@SP
A=M
M=D
// -------- and end 
@SP
M=M+1
// -------- C_PUSH begin 
@82
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- or begin 
@SP
M=M-1
@SP
A=M
M=D
@SP
M=M-1
@SP
A=M
D=D|M
@SP
A=M
M=D
// -------- or end 
@SP
M=M+1
// -------- not begin 
@SP
M=M-1
@SP
A=M
M=D
D=!M
@SP
A=M
M=D
// -------- not end 
@SP
M=M+1
