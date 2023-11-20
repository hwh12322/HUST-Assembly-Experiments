;  calcF, replicate
.686     
.model flat, stdcall
 printf          PROTO C :VARARG

.DATA


.CODE
calcF proc aa:dword, bb:dword, cc:dword
LOCAL mmll
    mov mmll, 5
    mov eax, 0
    mov eax, aa
	imul eax, mmll
	add eax, 100
	add eax, bb
	sub eax, cc
	sar eax, 7
	ret
calcF endp


replicate proc des:dword, sour:dword
   pushad
   mov eax, sour
   mov ebp, des
   mov esi, 0

L1:
   mov bl, byte ptr [eax+esi]
   mov byte ptr [ebp+esi], bl
   inc esi
   cmp esi, 23
   jl L1

   popad
   ret
 replicate endp

 END