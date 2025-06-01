import re
from functools import cache

nrs = list(map(int, re.findall(r"\d+", open("input").read())))

@cache
def spliteven(nr: str) -> (int, int):
    l = len(nr) // 2
    return int(nr[:l]), int(nr[l:])

@cache
def howmany(nr: int, blinks: int):
    if blinks == 0:
        return 1
    if nr == 0:
        return howmany(1, blinks - 1)
    if len(str(nr)) % 2 == 0:
        return sum(howmany(a, blinks - 1) for a in spliteven(str(nr)))
    return howmany(nr * 2024, blinks - 1)

part1 = sum(howmany(nr, 25) for nr in nrs)
part2 = sum(howmany(nr, 75) for nr in nrs)
print(part1, part2)
