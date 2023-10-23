#!/usr/bin/env python3
import sys
import math

def hex_to_decimal(hex_str):
    dec_num = sum(int(x, 16) * math.pow(16, len(hex_str)-i-1) for i, x in enumerate(hex_str)) 

    print('Hex: %s Dec: %.0f' % (hex_str.upper(), dec_num))
    
def main():
    sys.argv.pop(0)

    if len(sys.argv) == 0:
        print('Usage: h2d.py hex_number')
        sys.exit(1)

    for hex_str in sys.argv:
        hex_to_decimal(hex_str)


main()
