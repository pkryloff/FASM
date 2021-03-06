;----------------------------------------------------------------------------------------------------------------�
; ������ ����� �������, ���199
; ������� 12
; ���������� ��������
; ����������� ���������, ������� ������ ���������� ������ A[N], ��������� �� ��������� ������� A ����� ������ B �� ����������� ���������� ��������������
;----------------------------------------------------------------------------------------------------------------�

format PE console
include 'win32a.inc'
entry start

section '.data' data readable writable
strInputArrNum db 'Please, enter a positive integer number of elements but less than 200 ', 0
strIncorNum db 'Number of elements should be positive and less than 200, but you entered %d', 0
strInputInfo db 'Now you need to input elements one by one', 10, 0
strNewArr db 'New array B:', 10, 0
strInputEl db 'Value of [%d] ', 0
strScanInt db '%d', 0
strOutput db '[%d] = %d', 10, 0

arr_size dd 0
val1 dd ?
val2 dd ?
val3 dd ?
val4 dd 0
val5 dd 0
i dd ?
i2 dd 0
last_el_pos dd 0
arr rd 200
arrNew rd 200

section '.code' code readable executable

start:
call getArray ; ��������� ������.
call createNew ; �������� ������ �������.
call printArray1 ; ������� ������.
finish:
call [getch]
push 0
call [ExitProcess]
;----------------------------------------------------------------------------------------------------------------�
createNew:
mov [val2], esp
mov ecx, [arr_size]
add [last_el_pos], ecx
add [last_el_pos], ecx
add [last_el_pos], ecx
add [last_el_pos], ecx
sub [last_el_pos], 4
xor ecx, ecx
mov eax, arrNew ; ���������� ������ �� ������ ������� ������ �������.
mov ebx, arr ; ���������� ������ �� ������ ������� ������� �������.
mov ecx, [last_el_pos]
add ebx, ecx
add eax, ecx
xor ecx, ecx
mov [val3], 0 ; ����, ������������ ���������� �� ������ ������������� �������.

createStart:
mov [val1], ebx
mov [val5], eax
cmp ecx, [arr_size] ; ���������, �� ����� �� �� �� ������� �������.
jge createEnd ; ���� ����� - ��������� ���������� �������.
mov [i], ecx

mov ecx, [ebx]
cmp ecx, [val4] ; ���������, ���������� �� ��� ������������� �������.
jge allOkC ; ���� ���, ���������� ��� �������� � � ����� ������ � ���� � ���������� ��������.

cmp [val3], 0 ; ����� ��������� ����� �� ����� ��� ������������� �������.
jne allOkC ; ���� �� ������, ��������� ���������� ������ � ��������������� ���������.
inc [val3] ; ���� ������, ���������� ��� � ��������� � ���������� �������� ������� �������.
jmp allNotOkC

allOkC:
mov ecx, [ebx]
mov [eax], ecx ; ��������� �������� � ����� ������.
mov eax, [val5]
sub eax, 4 ; ���������� �� 1 ������� ����� � ����� �������.

allNotOkC:
mov ecx, [i]
inc ecx
mov ebx, [val1]
sub ebx, 4 ; ���������� �� 1 ������� ����� � ������ �������.
jmp createStart

createEnd:
mov esp, [val2] ; ���������� �������� ������� ������� � ����� �� ����� ������.
ret

;----------------------------------------------------------------------------------------------------------------�
printArray1:
mov [val2], esp ; ���������� ��������� ��������� �������.

push strNewArr
call [printf] ; Console: New array B:
mov ecx, [val3]
sub [arr_size], ecx
xor ecx, ecx ; �������� �������.
xor eax, eax
mov ebx, arrNew ; ���������� ������ �� ������� ��-�
add eax, 4
mul [val3]
add ebx, eax
xor ecx, ecx

outputtingStart1:
mov [val1], ebx
cmp ecx, [arr_size] ; ���������, �� ����� �� �� �� ������� �������.
jge endOutp1 ; ���� ����� - ��������� ���������� �������.
mov [i], ecx

mov eax, [i]
pushd [ebx]
push eax
push strOutput
call[printf] ; Console: [{������ � ������� �}] = {��-� ������� �}

mov ecx, [i]
inc ecx ; ����������� ������� ��-�.
mov ebx, [val1]
add ebx, 4 ; ��������� �� 1 ��-� ������ � �������� �������.
jmp outputtingStart1 ; ������������ � ������ �����.

endOutp1:
mov esp, [val2] ; ���������� �������� ������� ������ � ����� �� ����� ������.
ret
;----------------------------------------------------------------------------------------------------------------�
getArray:
mov [val2], esp ; ���������� ��������� ��������� �������.
push strInputArrNum
call [printf] ; Console: Please, enter a positive number of elements but less than 20
add esp, 4

push arr_size
push strScanInt
call [scanf] ; ��������� ��������� �����.
add esp, 8

mov eax, [arr_size] ; ��������� ���������.
cmp eax, 0 ; ���������, ������ �� ��� 0 ������ �������.
jbe failSize ; ���� ������ �����������, ��������� ����������, �����,
; ���������, �� ��������� �� �� ���������� ������ �������.
cmp eax, 200
jb getValBegin ; ���� ��������� ������ ����������� ������� [1;199], ��������� ���.

failSize:
push [arr_size]
push strIncorNum
call [printf] ; Console: Number of elements should be positive and less than 200, but you entered {��������� ������}
call finish

getValBegin:
push strInputInfo
call [printf]
;add esp, 4
xor ecx, ecx ; �������� �������
mov ebx, arr ; ���������� ������ �� ������� ��-�
getVal:
mov [val1], ebx
cmp ecx, [arr_size] ; ���������, �� ����� �� �� �� ������� �������.
jge endGetArray ; ���� ����� - ��������� ���������� �������.

mov [i], ecx
push ecx
push strInputEl
call [printf] ; Cosnole: Value of [{������� ��-� �������}]
add esp, 8

push ebx
push strScanInt
call [scanf] ; ��������� ����������� �����.
add esp, 8

mov ecx, [i]
inc ecx ; ����������� ������ �� 1.
mov ebx, [val1]
add ebx, 4
jmp getVal

endGetArray:
mov esp, [val2] ; ���������� �������� ������� ������� � ����� �� ����� ������.
ret
;----------------------------------------------------------------------------------------------------------------�
section '.idata' import data readable

library kernel, 'kernel32.dll',\
msvcrt, 'msvcrt.dll'

include 'api\user32.inc'
include 'api\kernel32.inc'
import kernel,\
ExitProcess, 'ExitProcess',\
HeapCreate,'HeapCreate',\
HeapAlloc,'HeapAlloc'
import msvcrt,\
printf, 'printf',\
scanf, 'scanf',\
getch, '_getch'