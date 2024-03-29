org 1
vector:
    .word interrupt

org 10
message:
    .word 'What is your name?',0
message_pointer:
    .word message
greeting:
    .word 'Hello, ', 0
greeting_pointer:
    .word greeting
exclamation:
    .word 33, 0
exclamation_pointer:
    .word exclamation
cycles:
    .word 0
in_port:
    .word 0
out_port:
    .word 1
flag:
    .word 0
line_feed:
    .word 10
tmp:
    .word 0

_start:
    ; вывод вопрошающего сообщения
    load message
    store cycles
    message_loop:
        load message_pointer
        inc
        store message_pointer
        load (message_pointer)
        out out_port
        load cycles
        dec
        store cycles
        jnz message_loop
    ; ожидание ввода
    ei
    spin_loop:
        load flag
        jz spin_loop
    ; вывод приветствия
    di
    load greeting
    store cycles
    greeting_loop:
        load greeting_pointer
        inc
        store greeting_pointer
        load (greeting_pointer)
        out out_port
        load cycles
        dec
        store cycles
        jnz greeting_loop
    load buffer_len
    dec
    store cycles
    name_loop:
        load (buffer_start_pointer)
        out out_port
        load buffer_start_pointer
        inc
        store buffer_start_pointer
        load cycles
        dec
        store cycles
        jnz name_loop
    exclamation_printing:
        load exclamation_pointer
        inc
        store exclamation_pointer
        load (exclamation_pointer)
        out out_port
    halt


interrupt:
    di ; запрет вложенных прерываний
    in in_port ; получение слова из порта ввода
    cmp line_feed
    jnz continue
    load flag
    inc
    store flag
    continue:
        store (buffer_pointer) ; сохранение в буфер
        load buffer_pointer ; сдвиг указателя
        inc
        store buffer_pointer
        load buffer_len ; увеличение длины
        inc
        store buffer_len
        returning:
            iret

buffer_len:
    .word 0
buffer_pointer:
    .word buffer
buffer_start_pointer:
    .word buffer
buffer:
    .word 0
