// -------- C_PUSH, constant, 3030 begin 
@3030
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, pointer, 0 begin 
@0
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
// -------- C_PUSH, constant, 3040 begin 
@3040
D=A
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
// -------- C_PUSH, constant, 32 begin 
@32
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, this, 2 begin 
@2
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
// -------- C_PUSH, constant, 46 begin 
@46
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- C_PUSH end 
// -------- C_POP, that, 6 begin 
@6
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
// -------- C_PUSH, pointer, 0 begin 
@0
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
// -------- C_PUSH, this, 2 begin 
@2
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
// -------- C_PUSH, that, 6 begin 
@6
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
