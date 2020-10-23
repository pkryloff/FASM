format PE console

entry start

include 'win32a.inc'

section 'data' data readable writable
        emptyStr db '%d', 0

        res dd ?

section 'code' code readable executable

        start:
                mov ebx, 0
                lp:
                    push ebx
                    push emptyStr
                    call [printf]

                    add ebx, 1
                    cmp ebx, 10
                jne lp

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