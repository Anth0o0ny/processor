org 10
message:
    .word 'Hello, world!', 0
pointer:
    .word message
in_port:
    .word 0
out_port:
    .word 1


_start:
    load (pointer)
    jz end
    out out_port
    load pointer
    inc
    store pointer
    jump _start

end:
    halt


