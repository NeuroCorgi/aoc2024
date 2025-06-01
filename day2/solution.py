from functools import reduce

with open("input") as input:
# with open("input_t") as input:
    data = [list(map(int, line.split())) for line in input.readlines()]


def cmp_an(acc, x):
    if not acc[0]: return (False, acc[1], x)

    if 1 <= (x - acc[2]) <= 3:
        return (True, acc[1], x)
    elif not acc[1]:
        return (True, True, acc[2])
    return (False, acc[1], x)

def cmp_dn(acc, x):
    if not acc[0]: return (False, acc[1], x)

    if 1 <= (acc[2] - x) <= 3:
        return (True, acc[1], x)
    elif not acc[1]:
        return (True, True, acc[2])
    return (False, acc[1], x)

def order(d):
    def asc(l: list[int]) -> bool:
        return reduce(lambda acc, x: (acc[0] and 1 <= (d * (x - acc[1])) <= 3, x), l, (True, l[0] - 2))[0]
    return asc

asc = order(1)
desc = order(-1)

def ascn(l: list[int]) -> bool:
    return (acc := reduce(cmp_an, l[1:], (True, False, l[0])))[0] or not acc[1]

def descn(l: list[int]) -> bool:
    return (acc := reduce(cmp_dn, l[1:], (True, False, l[0])))[0] or not acc[1]

print(ascn([42, 40, 38, 35, 32, 26]))

part1_1 = list(filter(lambda l: (asc(l) or any(asc(l[:i] + l[i + 1:]) for i in range(len(l)))) or (desc(l) or any(desc(l[:i] + l[i + 1:]) for i in range(len(l)))), data))
part1_2 = list(filter(lambda l: ascn(l) or descn(l), data))
print(len(part1_1), len(part1_2))
print(set(map(tuple, part1_1)) - set(map(tuple, part1_2)))
# part1 = list(filter(lambda a: desc(a), data))
# print(part1)
# part1 = len([l for l in data if asc(l) or desc(l)])
