import re
from itertools import count
from fractions import Fraction

pat = re.compile(r"(\d+)")

with open("input") as file:
    input = file.read()

def parse_section(s: str, part=1):
    a, b, r = s.strip().split("\n")
    (adx, ady) = map(int, pat.findall(a))
    (bdx, bdy) = map(int, pat.findall(b))
    (rx, ry) = map(lambda a: int(a) + (10000000000000 if part == 2 else 0), pat.findall(r))
    # print(rx, ry)

    r = rx - Fraction(bdx * ry, bdy)
    a = Fraction(r, adx - Fraction(ady * bdx, bdy))

    # a = Fraction(rx * bdy - ry, adx * bdy - ady * bdx)
    # print(a)

    if a.denominator == 1:
        b = (ry - a * ady) // bdy
        # print(a, b)
        return a.numerator * 3 + b
    # print(0)
    return 0

    den = ry % bdy
    # for x in range(1, 100):
    
    for x in count(1):
        # print(x, (ady * x) % bdy == den, adx * x + bdx * (ry - ady * x) // bdy == rx)
        if (ady * x) % bdy == den and adx * x + bdx * (ry - ady * x) // bdy == rx:
            # print(x)
            return x * 3 + (ry - ady * x) // bdy

        if adx * x + bdx * (ry - ady * x) // bdy > rx: break
        if x > 1000000000000:
            break
        
    return 0

s = input.split("\n\n")
print(sum(parse_section(s, part=1) for s in s))
print(sum(parse_section(s, part=2) for s in s))
