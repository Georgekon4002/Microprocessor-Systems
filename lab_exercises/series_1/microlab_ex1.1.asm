.include "m328PBdef.inc"
    .DEF A=r16
    .DEF B=r17
    .DEF C=r18
    .DEF D=r19
    .DEF temp=r20
    .DEF F0=r21
    .DEF F1=r22
    .cseg
    .org 0
    rjmp start

start:
    clr temp
    out DDRB,temp ;PORTB as input
    ser temp
    out DDRC,temp ;PORTC as output
    out PORTB,temp ;Pull-up PORTB
   
loopa:
    in temp,PINB ;Input from PORTB
    mov A,temp ;A=bit0
    lsr temp ;Right Shift -> Get LSB bit0
    mov B,temp ;B=bit1
    lsr temp 
    mov C,temp ;C=bit2
    lsr temp
    mov D,temp ;D=bit3
    mov F0,A ;F0=A
    com F0 ;F0=A'
    and F0,B ;F0=A'B
    mov temp,D
    com temp ;temp=D'
    and temp,C ;temp=CD'
    or F0,temp ;F0=A'B+CD'
    mov F1,D ;F1=D
    com F1 ;F1=D'
    or F1,A ;F1=A+D'
    mov temp,C 
    com temp ;temp=C'
    or temp,B ;temp=B+C'
    and F1,temp ;F1=(A+D')(B+C')
    andi F0,1 
    andi F1,1
    lsl F1
    or F1,F0
    out PORTC,F1 ;Output from PORTC
    rjmp loopa