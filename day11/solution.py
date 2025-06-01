from itertools import chain
from functools import cache

with open("input") as file:
    stones = list(map(int, file.read().split()))

@cache
def transform(s: int, n: int) -> int:
    if n == 0: return 1
    match s:
        case 0:
            return transform(1, n - 1)
        case s if len(str(s)) % 2 == 0:
            ss = str(s)
            return transform(int(ss[:len(ss)//2]), n - 1) + transform(int(ss[len(ss)//2:]), n - 1)
        case s:
            return transform(s * 2024, n - 1)

def apply(s, n):
    s = [s]
    for _ in range(n):
        s = chain.from_iterable(map(transform, s))
    return list(s)

# s1 = sum(transform(s, 25) for s in stones)
# s1 = sum(transform(s, 25) for s in stones)
s1 = sum(transform(s, 75) for s in stones)
# s2 = sum(map(lambda s: transform(s, 55), stones))
# s3 = sum(map(lambda s: transform(s, 75), stones))
print(s1)
