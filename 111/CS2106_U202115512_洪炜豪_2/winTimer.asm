;;
;;win32汇编计时子程序
;;使用方法：在你的.asm文件中加入如下语句：
;; include winTimer.asm
;;
;; ... ...
;; invoke winTimer 0 ;;启动计时
;; ... ... ;;需要计时的程序
;; ... ...
;; invoke winTimer 1 ;;结束计时并显示计时信息（毫秒）
;;

.686P
.model flat, c

includelib kernel32.lib
includelib libcmt.lib
includelib legacy_stdio_definitions.lib
includelib Winmm.lib
 
Sleep proto stdcall: dword
;timeGetTime proto stdcall
GetTickCount proto stdcall
printf proto c: vararg
ExitProcess proto stdcall: dword

.data
__t1 dd ?
__t2 dd ?
__fmtTime db 0ah, 0dh, "Time elapsed is %ld ms", 2 dup(0ah, 0dh), 0

.code
winTimer proc stdcall, flag: DWORD
 jmp __L1
;__L1: call timeGetTime
__L1: call GetTickCount
 cmp flag, 0
 jnz __L2
 mov __t1, eax
 ret 4
__L2: mov __t2, eax
 sub eax, __t1
 invoke printf, offset __fmtTime, eax
 ret 4
winTimer endp

main proc
 invoke winTimer, 0
 invoke Sleep, 1000
 invoke winTimer, 1
 invoke ExitProcess, 0
main endp
end
