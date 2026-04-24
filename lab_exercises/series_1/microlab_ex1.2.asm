.include "m328PBdef.inc"
.cseg
.org 0
rjmp reset

reset:
    ldi r24,low(RAMEND)	
    out SPL,r24
    ldi r24,high(RAMEND)
    out SPH,r24
start:
    ldi r24,low(1000)          
    ldi r25,high(1000)
    ldi r16,0b11111111
    out DDRD,r16
    ldi r16,0b00000001
spleft:
    out PORTD,r16
    rcall wait_msec
    rcall wait_msec
    rcall wait_msec  
    lsl r16
    brcc spleft
    ldi r16,0b01000000
    rcall wait_msec
    rcall wait_msec
spright:
    out PORTD,r16
    rcall wait_msec
    rcall wait_msec
    rcall wait_msec  
    lsr r16
    brcc spright
    ldi r16,0b00000010
    rcall wait_msec
    rcall wait_msec
    rjmp spleft 

wait_msec:
    ldi r18,255
loop1:
    ldi r19,255
loop2:
    dec r19
    brne loop2
    dec r18
    brne loop1
    ret