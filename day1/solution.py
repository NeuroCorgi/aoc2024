from collections import Counter

with open("input") as input:
    data = map(lambda line: line.split(), input.readlines())

lc, rc = zip(*data)
lc = list(map(int, lc))
rc = list(map(int, rc))

c = Counter(rc)

diff = sum(map(lambda l, r: abs(l - r), lc, rc))
print(diff)

score = sum(map(lambda n: n * c[n], lc))
print(score)
