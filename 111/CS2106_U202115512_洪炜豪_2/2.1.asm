.686P 
.model flat, c
  ExitProcess proto stdcall :dword
  includelib  kernel32.lib
  printf      proto c :vararg
  scanf      proto c :vararg
  includelib  libcmt.lib
  includelib  legacy_stdio_definitions.lib


timeGetTime proto stdcall
includelib  Winmm.lib

.DATA
__t1		dd ?
__t2		dd ?
__fmtTime	db	0ah, 0dh, "Time consumed is %ld ms", 2 dup(0ah, 0dh), 0

.CODE
winTimer	proc stdcall, flag : DWORD
    jmp	__L1
__L1: 
    call timeGetTime
    cmp	flag, 0
    jnz	__L2
    mov	__t1, eax
    ret	4
__L2: 
    mov	__t2, eax
    sub	eax, __t1
    invoke	printf, offset __fmtTime, eax
    ret	4
winTimer	endp

.data
count dd 1
N dd 5

SAMPLES  STRUCT
	SAMID  DB 6 DUP(0)   ;每组数据的流水号
	SDA   DD  ?      ;状态信息a
	SDB   DD  ?      ;状态信息b
	SDC   DD  ?      ;状态信息c
	SF    DD  ?      ;处理结果f
SAMPLES  ENDS

SAMPLE  SAMPLES  <'00001',321,432,10,?>
        SAMPLES  <'00002',2560,0,100,?>
        SAMPLES  <'00003',4000,5,6,?>
        SAMPLES  2 DUP(<>)       ;剩下的N-3组信息的初始值都相同并不影响实验效果

LOWF SAMPLES 5 dup(<>)
MIDF SAMPLES 5 dup(<>)
HIGHF SAMPLES 5 dup(<>)

lpfmt db "%s", 0ah, 0dh, 0
lpfmt1 db "%d", 0ah, 0dh, 0

.stack   200
.code

main proc  

invoke winTimer, 0
L:
	mov ecx, 0
	mov edx, 0      ;low
	mov esi, 0		;mid
	mov edi, 0		;high

LOOPA:

mov eax,SAMPLE[ecx].SDA
imul eax,5
add eax,SAMPLE[ecx].SDB
sub eax,SAMPLE[ecx].SDC
add eax,100
sar eax,7

cmp eax,100
jg HIGHN
je MIDN
jl LOWN


L0:
	inc count
	cmp count, 100000000
	jg Print
	add ecx,22
	cmp ecx,88
	jl LOOPA
	jmp L

Print:
	invoke printf,offset lpfmt,OFFSET MIDF[0].SAMID
	invoke printf,offset lpfmt1, MIDF[0].SDA
	invoke printf,offset lpfmt,OFFSET LOWF[0].SAMID
	invoke printf,offset lpfmt1, LOWF[0].SDA
	invoke printf,offset lpfmt,OFFSET HIGHF[0].SAMID
	invoke printf,offset lpfmt1, HIGHF[0].SDA
	invoke winTimer, 1
	invoke ExitProcess, 0

LOWN:
	mov LOWF[edx].SF,eax
	mov ebx, SAMPLE[ecx].SDA
	mov LOWF[edx].SDA, ebx
	mov ebx, SAMPLE[ecx].SDB
	mov LOWF[edx].SDB, ebx
	mov ebx, SAMPLE[ecx].SDC
	mov LOWF[edx].SDC, ebx
	mov ebp, 0

LOWN1:
    mov ebx, dword ptr SAMPLE[ecx].SAMID[ebp]
	mov dword ptr LOWF[edx].SAMID[ebp], ebx
	Inc ebp
	cmp ebp, 6
	jle LOWN1
	add edx,22
	jmp L0

MIDN:
    mov MIDF[esi].SF, eax
	mov ebx, SAMPLE[ecx].SDA
	mov MIDF[esi].SDA, ebx
	mov ebx, SAMPLE[ecx].SDB
	mov MIDF[esi].SDB, ebx
	mov ebx, SAMPLE[ecx].SDC
	mov MIDF[esi].SDC, ebx
	mov ebp, 0

MIDN1:
	mov ebx, dword ptr SAMPLE[ecx].SAMID[ebp]
	mov dword ptr MIDF[esi].SAMID[ebp], ebx
	Inc ebp
	cmp ebp, 6
	jle MIDN1
	add esi,22
	jmp L0

HIGHN:
    mov HIGHF[edi].SF, eax
	mov ebx, SAMPLE[ecx].SDA
	mov HIGHF[edi].SDA, ebx
	mov ebx, SAMPLE[ecx].SDB
	mov HIGHF[edi].SDB, ebx
	mov ebx, SAMPLE[ecx].SDC
	mov HIGHF[edi].SDC, ebx
	mov ebp, 0

HIGHN1:
	mov ebx, dword ptr SAMPLE[ecx].SAMID[ebp]
	mov dword ptr HIGHF[edi].SAMID[ebp], ebx
	Inc ebp
	cmp ebp, 6
	jle HIGHN1
	add edi,22
	jmp L0


Exit:
	invoke winTimer, 1
	invoke ExitProcess,0

main  endp
end
