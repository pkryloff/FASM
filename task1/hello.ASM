format PE console


include 'win32a.inc'

entry start

section '.data' data readable writeable
        strHello db 'Hello World!', 0

        NULL = 0

section '.code' code executable readable

        start:
                push strHello
                call [printf]

                call [getch]

                push NULL
                call [ExitProcess]
      
section '.idata' import data readable

        library kernel32, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel32,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch'