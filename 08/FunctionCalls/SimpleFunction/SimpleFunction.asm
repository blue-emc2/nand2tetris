// -------- function SimpleFunction.test begin 
(SimpleFunction.test)
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
// -------- function SimpleFunction.test end 
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
// -------- C_PUSH, local, 1 begin 
@1
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
// -------- return begin 
@LCL
AD=M
@R13
M=D
@R13
D=M
@5
AD=D-A
D=M
@R14
M=D
@SP
M=M-1
@SP
A=M
D=M
@ARG
A=M
M=D
@ARG
AD=M+1
@SP
M=D
@R13
D=M
@1
AD=D-A
D=M
@THAT
M=D
@R13
D=M
@2
AD=D-A
D=M
@THIS
M=D
@R13
D=M
@3
AD=D-A
D=M
@ARG
M=D
@R13
D=M
@4
AD=D-A
D=M
@LCL
M=D
@R14
A=M
0;JMP
// -------- return end 
