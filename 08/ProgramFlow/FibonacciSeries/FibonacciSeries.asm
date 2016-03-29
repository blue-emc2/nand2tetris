// -------- C_PUSH, argument, 1 begin 
@1
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
// -------- C_POP, pointer, 1 begin 
@1
D=A
@3
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
// -------- C_PUSH, constant, 0 begin 
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, that, 0 begin 
@0
D=A
@THAT
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
// -------- C_PUSH, constant, 1 begin 
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, that, 1 begin 
@1
D=A
@THAT
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
// -------- C_PUSH, constant, 2 begin 
@2
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
// -------- MAIN_LOOP_START begin 
(MAIN_LOOP_START)
// -------- MAIN_LOOP_START end 
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
// -------- COMPUTE_ELEMENT begin 
@SP
M=M-1
@SP
A=M
D=M
@R13
M=D
D=M
@COMPUTE_ELEMENT
D;JNE
@COMPUTE_ELEMENT_END
0;JMP
(COMPUTE_ELEMENT_END)
// -------- COMPUTE_ELEMENT end 
// -------- END_PROGRAM begin 
@END_PROGRAM
0;JMP
// -------- END_PROGRAM end 
// -------- COMPUTE_ELEMENT begin 
(COMPUTE_ELEMENT)
// -------- COMPUTE_ELEMENT end 
// -------- C_PUSH, that, 0 begin 
@0
D=A
@THAT
A=M
AD=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, that, 1 begin 
@1
D=A
@THAT
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
// -------- C_POP, that, 2 begin 
@2
D=A
@THAT
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
// -------- C_PUSH, pointer, 1 begin 
@1
D=A
@3
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
// -------- C_POP, pointer, 1 begin 
@1
D=A
@3
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
// -------- MAIN_LOOP_START begin 
@MAIN_LOOP_START
0;JMP
// -------- MAIN_LOOP_START end 
// -------- END_PROGRAM begin 
(END_PROGRAM)
// -------- END_PROGRAM end 
