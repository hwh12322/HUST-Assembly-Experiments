.686P 
.model flat, c
  ExitProcess proto stdcall :dword
  includelib  kernel32.lib
  printf      proto c :vararg
  scanf      proto c :vararg
  includelib  libcmt.lib
  includelib  legacy_stdio_definitions.lib

.DATA
SAMID  DB 6 DUP(0)   
SDA   DD  1145    
SDB   DD  -1145      
SDC   DD   1919   
SF    DD   0      
LOWF DD 5 dup(0)
MIDF DD 5 dup(0)
HIGHF DD 5 dup(0)   
lpfmt db "%d", 0ah, 0dh, 0
.stack   200



.code

main proc  
mov eax,SDA
mov edx,0
imul eax,5
add eax,SDB
sub eax,SDC
add eax,100
shr eax,7


mov SF,eax
cmp SF,100
je P
jl Q
jg W


Q:
mov SF,eax
;invoke printf, offset lpfmt,SF
invoke ExitProcess,0

P:
mov SF,eax
;invoke printf, offset lpfmt,SF
invoke ExitProcess,0

W:
mov SF,eax
;invoke printf, offset lpfmt,SF
invoke ExitProcess,0



main  endp
end
