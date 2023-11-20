.686     
.model flat, stdcall
 ExitProcess PROTO :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 scanf    PROTO C : dword,:vararg

VirtualProtect proto : dword, :dword, :dword, :dword
calcF proto :dword, :dword, :dword
replicate proto :dword, :dword
printMID proto

stringcmp MACRO truevalue, input			;字符串比较宏指令
   LOCAL cnt,  cor
   mov ecx, 0
cnt:
   mov al, truevalue[ecx]
   mov bl, input[ecx]
   inc ecx
   cmp al, bl
   jne wrong
   cmp al, 0
   je cor
   jmp cnt

cor:

ENDM


.DATA
leng1 dd 0
leng2 dd 0
;password db '1919810',0
password db '1' xor 'X','9' xor 'X','1' xor 'X','9' xor 'X','8' xor 'X','1' xor 'X','0' xor 'X',0
;username  db '114514',0
username db '1' xor 'X','1' xor 'X','4' xor 'X','5' xor 'X','1' xor 'X','4' xor 'X',0

welcome db 'HELLO, PLEASE LOGIN',10,10,0
 exit_tip db 'Click Q to quit, click R to redo: ',0
 interference db 'You will never break this',0
 command_error db 'Command not found, please input again.',10,0
 data_a db 'A:' ,0
 data_b db 'B:' ,0
 data_c db 'C:' ,0
 data_f db 'F:' ,0

buf1 db 'Welcome！', 0
buf2 db '请输入用户名和密码：', 0
buf3 db '错误达到三次，程序退出！', 0
buf4 db '用户名或者密码错误，请重新输入！', 0
buf5 db '输入‘R’重新执行数据处理，输入‘Q’退出：', 0

format2 db "%s",0    ;用于scanf函数格式化输入.
lpfmt2 db "%s", 0ah, 0dh, 0
lpfmt3 db "%d", 0ah, 0dh, 0

sdaprint db 'SDA:%d', 0ah, 0dh, 0
sdbprint db 'SDB:%d', 0ah, 0dh, 0
sdcprint db 'SDC:%d', 0ah, 0dh, 0
sfprint db 'SF:%d', 0ah, 0dh, 0ah, 0dh, 0
samidprint db 'SAMID:%s', 0ah, 0dh, 0


value1 db 11 dup(0)   ;存储用户输入username
value2 db 11 dup(0)	;存储用户输入password

SAMPLES  STRUCT
	SAMID  DB 7 DUP(0)   ;每组数据的流水号
	SDA   DD  ?      ;状态信息a
	SDB   DD  ?      ;状态信息b
	SDC   DD  ?      ;状态信息c
	SF    DD  ?      ;处理结果f
SAMPLES  ENDS

SAMPLE  SAMPLES  <'000001',321,432,10,?>;low
        SAMPLES  <'000002',2560,0,100,?>;mid
        SAMPLES  <'000003',4000,5,6,?>;high
		SAMPLES  <'000004', 2540, 1919, 1919, ?>;mid
		SAMPLES  <'000005', 2540, 1145, 1145, ?>;mid

LOWF SAMPLES 5 dup(<>)
MIDF SAMPLES 5 dup(<>)
HIGHF SAMPLES 5 dup(<>)

count dd ?			;用户输入计数
choice db ?			;最后的r或者q
desptr dd ?
sourptr dd ?
flag db 1

 machine_code db 0B8H,00,00,00,00
 lenTH EQU $-machine_code 
 oldprotect dd ?

.STACK 200



.CODE

main proc c

 mov count, 1
mov eax,lenTH 
mov ebx,40h
lea ecx,CopyHere
invoke VirtualProtect,ecx,eax,ebx,offset oldprotect 
mov ecx,lenTH
mov edi,offset CopyHere
mov esi,offset machine_code 
CopyCode:
mov al,[esi] 
mov [edi],al 
inc esi 
inc edi
loop CopyCode 
CopyHere:
db lenTH dup(0)
    mov ecx, 0

Enter1:						
    cmp count, 3
    jg Exit
    invoke printf,offset lpfmt2,offset buf2
    invoke scanf,offset format2,offset value1
    invoke scanf,offset format2,offset value2
length1:
    cmp byte ptr value1[eax], 0
    je outer1
    inc eax
    mov leng1,eax
    jmp length1
outer1:
    cmp leng1,6
    jne wrong
	mov eax,0
length2:
    cmp byte ptr value2[eax], 0
    je outer2
    inc eax
    mov leng2,eax
    jmp length2
outer2:
     cmp leng2,7
    jne wrong
    mov eax, 0
    mov ecx, 0
    stringcmp username, value1
    stringcmp password, value2
    jmp Pass
wrong:
   inc count
   invoke printf,offset lpfmt2,offset buf4
   jmp Enter1

PASS:
   invoke printf,offset lpfmt2,offset buf1			;双密正确，跳转到处理数据
   jmp L


Exit:
   invoke printf,offset lpfmt2,offset buf3			;三次错误，程序结束
   invoke ExitProcess, 0

L:
	mov ecx, 0
	mov eax, 0
	mov edx, 0      ;low
	mov esi, 0		;mid
	mov edi, 0		;high

LOOPA:

	invoke calcF, SAMPLE[ecx].SDA, SAMPLE[ecx].SDB, SAMPLE[ecx].SDC
	mov SAMPLE[ecx].SF, eax
	cmp eax,100
	jg HIGHN
	je MIDN
	jl LOWN
	mov eax,3
    mov ebx,9
    mov ecx,6
    mov edx,0

L0:
	add ecx,23
	cmp ecx,92
	jle LOOPA
	invoke printMID
	jmp Last

LOWN:
	lea ebx, LOWF[edx]
	mov desptr,ebx
	lea ebx, SAMPLE[ecx]
	mov sourptr,ebx
	invoke replicate,desptr,sourptr
	add edx,23
	jmp L0

MIDN:
    lea ebx, MIDF[esi]
	mov desptr,ebx
	lea ebx, SAMPLE[ecx]
	mov sourptr,ebx
	invoke replicate,desptr,sourptr
	add esi,23
	jmp L0


HIGHN:
    lea ebx, HIGHF[edi]
	mov desptr,ebx
	lea ebx, SAMPLE[ecx]
	mov sourptr,ebx
	invoke replicate,desptr,sourptr
	add edi,23
	jmp L0


Last:
   invoke printf,offset lpfmt2,offset buf5
   invoke scanf,offset format2,offset choice
   cmp choice, 'r'
   je L
   cmp choice, 'q'
   jne Last
   invoke ExitProcess, 0

main endp

 printMID proc
    pushad
  
	sub esi, 23
	mov ebx, 0
	lea edi, MIDF
L1:
    invoke printf, offset samidprint, edi
	invoke printf, offset sdaprint, MIDF[ebx].SDA
    invoke printf, offset sdbprint, MIDF[ebx].SDB
    invoke printf, offset sdcprint, MIDF[ebx].SDC
    invoke printf, offset sfprint, MIDF[ebx].SF
    add ebx, 23
    add edi, 23
    cmp ebx, esi
    jle L1

	popad
    ret
	printMID endp





END


