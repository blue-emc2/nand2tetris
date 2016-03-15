// -------- C_PUSH, constant, 10 begin 
@10
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
// -------- C_PUSH, constant, 21 begin 
@21
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, constant, 22 begin 
@22
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, argument, 2 begin 
@2
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
// -------- C_POP, argument, 1 begin 
@1
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
// -------- C_PUSH, constant, 36 begin 
@36
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, this, 6 begin 
@6
D=A
@THIS
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
// -------- C_PUSH, constant, 42 begin 
@42
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, constant, 45 begin 
@45
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, that, 5 begin 
@5
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
// -------- C_PUSH, constant, 510 begin 
@510
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, temp, 6 begin 
@6
D=A
@5
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
// -------- C_PUSH, that, 5 begin 
@5
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
// -------- C_PUSH, this, 6 begin 
@6
D=A
@THIS
A=M
AD=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, this, 6 begin 
@6
D=A
@THIS
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
// -------- C_PUSH, temp, 6 begin 
@6
D=A
@5
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
