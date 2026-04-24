#define F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

volatile uint16_t counter = 0;
volatile uint8_t led_on = 0;

ISR(INT1_vect) // External INT1 ISR (PD3)
{
    counter = 0;
    led_on = 1;

    // Turn on PB0–PB3
    PORTB |= 0x0F;
    _delay_ms(500);

    // Turn off PB0–PB2, keep PB3 on
    PORTB &= ~(0x07);
    PORTB |= (1 << PB3);

    // Clear INT1 flag
    EIFR |= (1 << INTF1);
}

int main() {
    // Configure external interrupt on falling edge for INT1 (PD3)
    EICRA = (1 << ISC11); // ISC11 = 1, ISC10 = 0 → falling edge
    EIMSK = (1 << INT1);  // Enable INT1
    EIFR |= (1 << INTF1); // Clear interrupt flag

    sei(); // Enable global interrupts

    DDRB = 0x0F; // PB0–PB3 as outputs
    PORTB = 0x00;

    DDRD &= ~(1 << PD3); // PD3 as input
    PORTD |= (1 << PD3); // Enable pull-up on PD3

    while (1) {
        if (led_on) {
            if (counter < 5000) {
                _delay_ms(1);
                counter++;
            } else {
                // Time out, turn off PB3
                PORTB &= ~(1 << PB3);
                led_on = 0;
            }
        } else {
            _delay_ms(1); // Idle wait
        }
    }
}
