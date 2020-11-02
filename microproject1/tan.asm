format PE console
entry start
include 'win32a.inc'

section '.code' code readable executable
  sin:
    finit
    fld1
    fstp QWORD[delta]

    mov ecx, 0
    sin_loop:
    inc ecx
    fld QWORD[x]
    mov [i], ecx
    fidiv dword[i]
    fmul QWORD[delta]
    fstp QWORD[delta]

    mov eax, ecx
    and eax, 1
    cmp eax, 0
    je sin_loop

    fld QWORD[delta]
    fadd QWORD[sinres]
    fstp QWORD[sinres]

    fld QWORD[delta]
    fchs
    fstp QWORD[delta]

    cmp ecx, 1000
    jl sin_loop
    sin_end:
    ret

  cos:
    finit
    fld1
    fst QWORD[cosres]
    fchs
    fstp QWORD[delta]

    mov ecx, 0
    cos_loop:
    inc ecx
    fld QWORD[x]
    mov [i], ecx
    fidiv dword[i]
    fmul QWORD[delta]
    fstp QWORD[delta]

    mov eax, ecx
    and eax, 1
    cmp eax, 0
    jne cos_loop

    fld QWORD[delta]
    fadd QWORD[cosres]
    fstp QWORD[cosres]

    fld QWORD[delta]
    fchs
    fstp QWORD[delta]

    cmp ecx, 1000
    jl cos_loop
    cos_end:
    ret

  capX:
    finit
    fldpi
    fimul dword[two]
    fld QWORD[x]
    fst QWORD[oldx]
    fprem1
    fstp QWORD[x]

    fld QWORD[oldx]
    fld QWORD[x]
    fcompp
    fstsw ax
    sahf
    je capX_ret

    push dword[x+4]
    push dword[x]
    push dword[oldx+4]
    push dword[oldx]
    push printfFormat_mod
    call [printf]
    add esp, 20
    capX_ret:
    ret

  tan:
    finit
    fld QWORD[sinres]
    fdiv QWORD[cosres]
    fstp QWORD[tanres]
    ret

  start:
    push askForX
    call [printf]
    add esp, 4
    push x
    push scanfFormat
    call [scanf]
    add esp, 8
    cmp eax, 1
    jne wrongInput

    call capX
    call sin
    call cos
    call tan

    push dword[sinres+4]
    push dword[sinres]
    push dword[x+4]
    push dword[x]
    push printfFormat_sin
    call [printf]
    add esp, 20
    push dword[cosres+4]
    push dword[cosres]
    push dword[x+4]
    push dword[x]
    push printfFormat_cos
    call [printf]
    add esp, 20
    push dword[tanres+4]
    push dword[tanres]
    push dword[x+4]
    push dword[x]
    push printfFormat_tan
    call [printf]
    add esp, 20

    safeExit:
    call [getch]
    push 0
    call [exit]

    wrongInput:
    push wrongFromat
    call [printf]
    add esp, 4
    jmp safeExit

section '.data' data readable writable
  scanfFormat: db '%lf',0
  printfFormat_mod: db '%g mod 2pi = %g',10,0
  printfFormat_sin: db 'Firstly, we can find sin(%g) = %.15g',10,0
  printfFormat_cos: db 'Sesondly, we can find cos(%g) = %.15g',10,0
  printfFormat_tan: db 'Finaly, we can find answer: tan(%g) = %.15g',10,0
  askForX: db 'Please, enter x: ',0
  wrongFromat: db 'Wrong input (scanf cant find a float)',10,0
  two: dd 2
  i: dd 0
  x: dq 0
  oldx: dq 0
  sinres: dq 0
  cosres: dq 0
  tanres: dq 0
  delta: dq 0

section '.idata' import code readable
  library msvcrt, 'msvcrt.dll'
  import msvcrt, printf, 'printf', scanf, 'scanf', exit, '_exit', getch, '_getch'
