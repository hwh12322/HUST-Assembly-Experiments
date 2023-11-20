.686     
.model flat, stdcall
 ExitProcess PROTO :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 scanf    PROTO C : dword,:vararg

.DATA
leng db 0
password db '114514', 0
buf1 db 'Welcome!', 0
buf2 db 'Incorrect Password!', 0
message db 'Please input your password(No more than 10 words)：', 0
lpFmt	db	"%s",0ah, 0dh, 0
format2 db '%s',0    ;用于scanf函数格式化输入.
value db 11 dup(0)   ;存储scanf得到的用户输入

.STACK 200

.CODE
main proc c
	invoke printf,offset lpFmt,offset message
    invoke scanf,offset format2,offset value
    mov eax, 0
    mov ecx, 0

length1:
    cmp byte ptr value[ecx], 0
    je outer
    inc ecx
    inc leng
    jmp length1
outer:
    cmp leng,6
    jnz Exit
    mov eax, 0
    mov ecx, 0
L1:
    mov eax, offset value
    mov bl, password[ecx]
    cmp bl, [eax+ecx]
    jnz Exit
    inc ecx
    cmp byte ptr password[ecx], 0
    jnz L1

    invoke printf,offset lpFmt,offset buf1
    invoke ExitProcess, 0

Exit:
    invoke printf,offset lpFmt,offset buf2
    invoke ExitProcess, 0
main endp
END
