
import sys

"""
List all of the primes less than top
"""

def list_primes_below_top(top):
    for x in range(2, top):
        for y in range(2, x):
            if x % y == 0:
                # print(x, 'equals', y, '*', x//y)
                break
        else:
            print(x)


def main():
    if len(sys.argv) < 2:
        print(f'Usage {sys.argv[0]} top_number')
        sys.exit(1)

    top = int(sys.argv[1])

    list_primes_below_top(top)

main()
