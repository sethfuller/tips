#!/usr/bin/env python3
import sys
import math

def hex_to_decimal(hex_str):
    dec_num = sum(int(x, 16) * math.pow(16, len(hex_str)-i-1) for i, x in enumerate(hex_str)) 

    print('Hex: %s Dec: %.0f' % (hex_str.upper(), dec_num))
    return dec_num

def main():
    sys.argv.pop(0)

    if len(sys.argv) < 2:
        print('Usage: hex_div.py hex_number hex_number2')
        sys.exit(1)

    hex_str1 = sys.argv[0]
    dec_num1 = hex_to_decimal(hex_str1)
    hex_str2 = sys.argv[1]
    dec_num2 = hex_to_decimal(hex_str2)

    print('%.0f / %.0f = %.2f' % (dec_num1, dec_num2, dec_num1/dec_num2))


main()
