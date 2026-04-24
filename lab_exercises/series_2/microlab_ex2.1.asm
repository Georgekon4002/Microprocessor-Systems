.include "m328PBdef.inc"

.def count = r17
.def freeze = r18

.org 0x0
    rjmp reset

.org 0x004 ;INT1 Vector
    rjmp isr1

reset:
    ldi r24, LOW(RAMEND)
    out SPL, r24
    ldi r24, HIGH(RAMEND)
    out SPH, r24

    ;Init DDRs
    ser r24
    out DDRC, r24 ;PORTC as output
    clr r24
    out DDRD, r24 ;PORTD as input (Pull-up: When pressed=0)

    ;Interrupt on rising edge INT1
    ldi r24, (1 << ISC11) | (1 << ISC10)
    sts EICRA, r24

    ;Enable INT1
    ldi r24, (1 << INT1)
    out EIMSK, r24

    ;Enable global interrupts
    sei

    clr count
    clr freeze
    out PORTC, count    ;init display

main_loop:
    sbic PIND, 5 ;If PD5=0 (pressed), then skip
    rjmp not_frozen
    ldi freeze, 1
    rjmp main_loop

not_frozen:
    sbis PIND, 5 ;If PD5=1 (not pressed), then continue
    rjmp main_loop
    clr freeze
    rjmp main_loop

; ISR INT1
isr1:
	push r23 ;Save r24,17,18, SREG to stack
    push r24
    push r25
    in r25, SREG
    push r25

	cpi freeze, 1 ;Check if freeze is true
    breq end_isr ;If it is ignore interrupt

	inc count
    cpi count, 8
    brlo skip_reset
    clr count



skip_reset:
    out PORTC, count

    ; 300ms delay
    ldi r24, low(16*300)
    ldi r25, high(16*300) ;16 MHz frequency
delay1:
    ldi r23, 249 ;1 cycle
delay2:
    dec r23 ;1 cycle
    nop ;1 cycle
    brne delay2 ;1 or 2 cycles
    sbiw r24, 1 ;2 cycles
    brne delay1 ;1 or 2 cycles

    ldi r24, (1 << INTF1)
    out EIFR, r24    ; clear INT1 flag

end_isr:
    pop r25
    out SREG, r25
    pop r25
	pop r24
    pop r23
	reti