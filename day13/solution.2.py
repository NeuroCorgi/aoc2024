from math import *
import re
from fractions import *

def extended_gcd(a, b):
    if a == 0:
        return b, 0, 1

    gcd, x1, y1 = extended_gcd(b % a, a)

    x = y1 - (b // a) * x1
    y = x1

    return gcd, x, y

data = [[int(nr) for nr in re.findall(r"\d+", block)] for block in open("input_t1").read().split("\n\n")]

def costs(x1, x2, x, y1, y2, y):
    gcd, m, n = extended_gcd(x1, x2)    # find m, n, gcd so that x1 * m + x2 * n == gcd
    mul = x // gcd
    a0, b0 = mul * m, mul * n
    r = Fraction(y - a0 * y1 - b0 * y2, x2 // gcd * y1 - x1 // gcd * y2)
    d = 3 * (a0 + r.numerator * x2 // gcd) + b0 - r.numerator * x1 // gcd if r.denominator == 1 else 0
    
    print((a0 + r.numerator * x2 // gcd), b0 - r.numerator * x1 // gcd, d)
    return d

# part1 = sum(costs(dx1, dx2, x, dy1, dy2, y) for dx1, dy1, dx2, dy2, x, y in data)
part2 = sum(costs(dx1, dx2, x + 10000000000000, dy1, dy2, y + 10000000000000) for dx1, dy1, dx2, dy2, x, y in data)
# print(part1)                    # 480 26005
print(part2)                    # 875318608908 105620095782547
