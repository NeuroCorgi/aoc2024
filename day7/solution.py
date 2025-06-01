from itertools import product
from operator import add, mul
from functools import reduce

with open("input") as input:
    eqs = input.readlines()

def concat(a, b):
    n = 10 ** len(str(b))
    return a * n + b

def solve(eqs, ops):
    return sum(d for (d, ns) in eqs if d == reduce(lambda a, e: e[0](a, e[1]), 

ops = (add, mul, concat)

c = 0
for eq in eqs:
    d, ns = eq.split(": ")
    d = int(d)

    ns = list(map(int, ns.split()))
    os = product(ops, repeat=len(ns) - 1)

    if any(d == reduce(lambda a, e: e[0](a, e[1]), zip(o, ns[1:]), ns[0]) for o in os):
        c += d
    # print(d, ns)
print(c)
