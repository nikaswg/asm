;Колешко Кирилл В-24 ЛР-7
;Определить количество запятых в строке.
.model small
.stack 100h
.data
    find db 'Number of commas: $'  ; Сообщение о количестве запятых
    mes1 db 'Source string:', 0ah, 0dh, '$'
    string db 'This, is, a, test, string, with, commas,', 0ah, 0dh, '$'  ; Исходная строка
    mes2 db 0ah, 0dh, 'New string: ', 0ah, 0dh, '$'
    count db 0  ; Счетчик запятых
.code
main proc near
    mov ax, @data  ; Загрузка сегментных регистров
    mov ds, ax
    mov es, ax

    ; Очистка экрана
    mov ax, 0002h
    int 10h

    ; Вывод исходной строки
    mov ah, 09h
    lea dx, mes1
    int 21h
    lea dx, string
    int 21h

    ; Настройка для поиска
    cld  ; Сброс флага направления (поиск вперед)
    lea di, string  ; Загрузка адреса строки в DI
    mov cx, 50  ; Максимальная длина строки для поиска
    mov al, ','  ; Символ для поиска (запятая)
    xor bx, bx  ; Счетчик запятых (обнуляем)

search_loop:
    repne scasb  ; Поиск символа ',' в строке
    jne done  ; Если символ не найден, завершаем поиск
    inc bx  ; Увеличиваем счетчик запятых
    jmp search_loop  ; Продолжаем поиск

done:
    ; Сохраняем количество запятых
    mov count, bl

    ; Вывод результата
    mov ah, 09h
    lea dx, find
    int 21h

    ; Преобразуем количество запятых в ASCII и выводим
    mov al, count
    add al, '0'  ; Преобразуем число в символ
    mov ah, 02h
    mov dl, al
    int 21h

    ; Завершение программы
    mov ax, 4C00h
    int 21h
main endp
end main