format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        strA db 'Enter your fibonacci number (positive): ', 0
        strSpace db '%d', 0

        n dd ?

        temp dd ?
        prev dd 1
        curr dd 1

        NULL = 0

section '.code' code readable executable

        start:
                push strA
                call [printf]

                push n
                push strSpace
                call [scanf]

                cmp [n], 1
                je finish

                cmp [n], 2
                je finish

                sub [n], 2

                mov ebx, 0
                lp:
                    mov eax, [prev]
                    mov ecx, [curr]

                    mov [temp], eax
                    mov eax, ecx
                    add ecx, [temp]

                    mov [prev], eax
                    mov [curr], ecx

                    add ebx, 1
                    cmp ebx, [n]
                jne lp

                finish:

                    push [curr]
                    push strSpace
                    call [printf]

                    call [getch]

                    push NULL
                    call [ExitProcess]


section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'