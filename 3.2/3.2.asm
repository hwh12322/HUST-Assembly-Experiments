.686     
.model flat, stdcall
 ExitProcess PROTO :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 scanf    PROTO C : dword,:vararg


calcF proto :dword, :dword, :dword
replicate proto :dword, :dword
exitornot proto c:dword, :dword
pastedata proto c:dword
printMID proto c:dword, :dword
compare proto c:dword, :dword, :dword



.DATA
leng1 dd 0
leng2 dd 0
username db '114514', 0
password db '1919810', 0
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
choice dd ?			;最后的r或者q
flag dd ?
n dd ?
desptr dd ?
sourptr dd ?

.STACK 200



.CODE

main proc c
    mov count, 1
    mov eax, 0
    mov ecx, 0
Enter1:						
    mov flag, 1
    invoke compare, offset value1, offset value2, offset flag
    cmp flag, 1
    je Pass
wrong:
	invoke printf,offset lpfmt2,offset buf3
	invoke ExitProcess, 0
PASS:
    invoke printf,offset lpfmt2,offset buf1			;双密正确，跳转到处理数据

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


L0:
	add ecx,23
	cmp ecx,92
	jle LOOPA
	invoke printMID,offset MIDF,esi
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
	invoke exitornot,offset SAMPLE,offset n
	cmp n,0
	jg L
	jl Last
	invoke ExitProcess, 0

main endp



END