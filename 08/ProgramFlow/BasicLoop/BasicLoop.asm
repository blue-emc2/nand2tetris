// -------- C_PUSH, constant, 0 begin 
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, local, 0 begin 
@0
D=A
@LCL
A=M
AD=D+A
@R13
M=D
@SP
M=M-1
@SP
A=M
D=M
@R13
A=M
M=D
// -------- C_POP end 
// -------- LOOP_START begin 
(LOOP_START)
// -------- LOOP_START end 
// -------- C_PUSH, argument, 0 begin 
@0
D=A
@ARG
A=M
AD=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, local, 0 begin 
@0
D=A
@LCL
A=M
AD=D+A
D=M
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
// -------- C_POP, local, 0 begin 
@0
D=A
@LCL
A=M
AD=D+A
@R13
M=D
@SP
M=M-1
@SP
A=M
D=M
@R13
A=M
M=D
// -------- C_POP end 
// -------- C_PUSH, argument, 0 begin 
@0
D=A
@ARG
A=M
AD=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, constant, 1 begin 
@1
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
// -------- C_POP, argument, 0 begin 
@0
D=A
@ARG
A=M
AD=D+A
@R13
M=D
@SP
M=M-1
@SP
A=M
D=M
@R13
A=M
M=D
// -------- C_POP end 
// -------- C_PUSH, argument, 0 begin 
@0
D=A
@ARG
A=M
AD=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- LOOP_START begin 
@SP
M=M-1
@SP
A=M
D=M
@R13
M=D
D=M
@LOOP_START
D;JNE
@LOOP_START_END
0;JMP
(LOOP_START_END)
// -------- LOOP_START end 
// -------- C_PUSH, local, 0 begin 
@0
D=A
@LCL
A=M
AD=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
