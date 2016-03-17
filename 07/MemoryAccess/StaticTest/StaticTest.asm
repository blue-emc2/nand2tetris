// -------- C_PUSH, constant, 111 begin 
@111
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, constant, 333 begin 
@333
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, constant, 888 begin 
@888
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, static, 8 begin 
D=0
@24
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
// -------- C_POP, static, 3 begin 
D=0
@19
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
// -------- C_POP, static, 1 begin 
D=0
@17
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
// -------- C_PUSH, static, 3 begin 
D=0
@19
AD=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_PUSH, static, 1 begin 
D=0
@17
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
// -------- C_PUSH, static, 8 begin 
D=0
@24
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
