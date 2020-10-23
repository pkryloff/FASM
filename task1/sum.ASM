format PE console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        formatNum db '%d', 0

        resStr db 'Result: %d', 0
        fnStr db 'Input first number: ', 0
        snStr db 'Input second number: ', 0

        A dd ?
        B dd ?

        NULL = 0

section '.code' code readable executable

        start:
                push fnStr
                call [printf]

                push A
                push formatNum
                call [scanf]

                push snStr
                call [printf]

                push B
                push formatNum
                call [scanf]

                mov ecx, [A]
                add ecx, [B]

                push ecx
                push resStr
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
               getch, '_getch',\
               scanf, 'scanf'