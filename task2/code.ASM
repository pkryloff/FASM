;----------------------------------------------------------------------------------------------------------------—
; Крылов Павел Юрьевич, БПИ199
; Вариант 12
; одномерных массивов
; Разработать программу, которая вводит одномерный массив A[N], формирует из элементов массива A новый массив B за исключением последнего отрицательного
;----------------------------------------------------------------------------------------------------------------—

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
call getArray ; Заполняем массив.
call createNew ; Создание нового массива.
call printArray1 ; Выводим массив.
finish:
call [getch]
push 0
call [ExitProcess]
;----------------------------------------------------------------------------------------------------------------—
createNew:
mov [val2], esp
mov ecx, [arr_size]
add [last_el_pos], ecx
add [last_el_pos], ecx
add [last_el_pos], ecx
add [last_el_pos], ecx
sub [last_el_pos], 4
xor ecx, ecx
mov eax, arrNew ; Запоминаем ссылку на первый элемент нового массива.
mov ebx, arr ; Запоминаем ссылку на первый элемент старого массива.
mov ecx, [last_el_pos]
add ebx, ecx
add eax, ecx
xor ecx, ecx
mov [val3], 0 ; Флаг, показывающий встретился ли первый отрицательный элемент.

createStart:
mov [val1], ebx
mov [val5], eax
cmp ecx, [arr_size] ; Проверяем, не вышли ли мы за границу массива.
jge createEnd ; Если вышли - завершаем заполнение массива.
mov [i], ecx

mov ecx, [ebx]
cmp ecx, [val4] ; Проверяем, встретился ли нам Отрицательный элемент.
jge allOkC ; Если нет, записываем его значение в в новый массив и идем к следующему элементу.

cmp [val3], 0 ; Иначе проверяем какой по счету это отрицательный элемент.
jne allOkC ; Если не первый, поступаем аналогично случаю с неотрицательным элементом.
inc [val3] ; Если первый, пропускаем его и переходим к следующему элементу старого массива.
jmp allNotOkC

allOkC:
mov ecx, [ebx]
mov [eax], ecx ; Сохраняем значение в новый массив.
mov eax, [val5]
sub eax, 4 ; Сдвигаемся на 1 элемент далее в новом массиве.

allNotOkC:
mov ecx, [i]
inc ecx
mov ebx, [val1]
sub ebx, 4 ; Сдвигаемся на 1 элемент далее в старом массиве.
jmp createStart

createEnd:
mov esp, [val2] ; Возвращаем значение позиции функции в стеке во время вызова.
ret

;----------------------------------------------------------------------------------------------------------------—
printArray1:
mov [val2], esp ; Запоминаем начальное положение функции.

push strNewArr
call [printf] ; Console: New array B:
mov ecx, [val3]
sub [arr_size], ecx
xor ecx, ecx ; Обнуляем регистр.
xor eax, eax
mov ebx, arrNew ; Запоминаем ссылку на крайний эл-т
add eax, 4
mul [val3]
add ebx, eax
xor ecx, ecx

outputtingStart1:
mov [val1], ebx
cmp ecx, [arr_size] ; Проверяем, не вышли ли мы за границу массива.
jge endOutp1 ; Если вышли - завершаем заполнение массива.
mov [i], ecx

mov eax, [i]
pushd [ebx]
push eax
push strOutput
call[printf] ; Console: [{индекс в массиве В}] = {эл-т массива В}

mov ecx, [i]
inc ecx ; Увеличиваем счетчик эл-в.
mov ebx, [val1]
add ebx, 4 ; Смещаемся на 1 эл-т вперед в исходном массиве.
jmp outputtingStart1 ; Возвращаемся к началу цикла.

endOutp1:
mov esp, [val2] ; Возвращаем значение позиции функци в стеке во время вызова.
ret
;----------------------------------------------------------------------------------------------------------------—
getArray:
mov [val2], esp ; Запоминаем начальное положение функции.
push strInputArrNum
call [printf] ; Console: Please, enter a positive number of elements but less than 20
add esp, 4

push arr_size
push strScanInt
call [scanf] ; Считываем введенное число.
add esp, 8

mov eax, [arr_size] ; Сохраняем введенный.
cmp eax, 0 ; Проверяем, больше ли чем 0 размер массива.
jbe failSize ; Если размер отрицателен, завершаем выполнение, иначе,
; проверяем, не превышает ли он допустимый размер массива.
cmp eax, 200
jb getValBegin ; Если введенный размер принадлежит отрезку [1;199], заполняем его.

failSize:
push [arr_size]
push strIncorNum
call [printf] ; Console: Number of elements should be positive and less than 200, but you entered {введенный размер}
call finish

getValBegin:
push strInputInfo
call [printf]
;add esp, 4
xor ecx, ecx ; Обнуляем регистр
mov ebx, arr ; Запоминаем ссылку на крайний эл-т
getVal:
mov [val1], ebx
cmp ecx, [arr_size] ; Проверяем, не вышли ли мы за границу массива.
jge endGetArray ; Если вышли - завершаем заполнение массива.

mov [i], ecx
push ecx
push strInputEl
call [printf] ; Cosnole: Value of [{текущий эл-т массива}]
add esp, 8

push ebx
push strScanInt
call [scanf] ; Считываем натуральное число.
add esp, 8

mov ecx, [i]
inc ecx ; Увеличиваем индекс на 1.
mov ebx, [val1]
add ebx, 4
jmp getVal

endGetArray:
mov esp, [val2] ; Возвращаем значение позиции функции в стеке во время вызова.
ret
;----------------------------------------------------------------------------------------------------------------—
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