;;说明：(1) 为了在vs2019的汇编程序中调用C的函数，需要执行vs2019产生的初始化代码。
;;          该初始化代码会调用libcmt.lib中的_mainCRTStartup()，再由_mainCRTStartup()调用main()。
;;			所以，我们需要定义main函数（子程序）,同时需要将libcmt.lib包含进去（includelib libcmt.lib）
;;      (2) 由于程序入口是main()，因此不能再程序末尾的end语句上加标号，即不能 end start（start是第一条语句的标号）
;;      (3) C函数（如_mainCRTStartup()、printf()）都是按c规范调用函数，所以必须有语句 .model flat,c（不能是stdcall）
;;      (4) printf函数是在legacy_stdio_definitions.lib中定义的（需要includelib  legacy_stdio_definitions.lib）
;;功能：本程序演示了在汇编中调用C的scanf()和printf().


.686     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

.DATA
lpFmt	db	"%s",0ah, 0dh, 0
  X   DB  10, 255, -1
  Y   DW  10, 255, -1
  Z   DD  10, 255, -1
  U   DW  ($-Z)/4
  STR1 DB  'Good', 0
  P   DD  X,  Y
  Q   DB   2 DUP (5, 6)
  buf1   db  '00123456789',0
  buf2   db  12 dup(0)   ; 12个字节的空间，初值均为 0 
.STACK 200
.CODE
main proc c
   MOV  ESI,OFFSET buf1
   MOV  EDI,OFFSET buf2 
   MOV  ECX,0
L1:
   MOV  EAX, [ESI]   ;如果总数不是12个字节，还能每次传送4个字节吗？
   MOV  [EDI],EAX
   ADD  ESI, 4
   ADD  EDI, 4
   ADD  ECX, 4
   CMP  ECX,12
   JNZ  L1
   invoke printf,offset lpFmt,OFFSET buf1
   invoke printf,offset lpFmt,OFFSET buf2
   invoke ExitProcess, 0
main endp
END
