from collections import defaultdict
from itertools import combinations
from math import gcd

def bound(g, p):
    return 0 <= p[0] < len(g) and 0 <= p[1] < len(g[0])

with open("input") as file:
    data = [list(line.strip()) for line in file.readlines()]
print(len(data), len(data[0]))

an = defaultdict(set)
[an[c].add((i, j))
 for i, line in enumerate(data)
 for j, c in enumerate(line)
 if c != '.']
            # an[c].add((i, j))

q = 0
qs = set()
q2 = 0
qs2 = set()
for c, ans in an.items():
    for (a1, a2) in combinations(ans, 2):
        qs2.add(a1)
        qs2.add(a2)
        q2 += 2
        dx0 = a1[0] - a2[0]
        dy0 = a1[1] - a2[1]
        p1 = (a1[0] + dx0), (a1[1] + dy0)
        if bound(data, p1):
            qs.add(p1)
        p2 = (a2[0] - dx0), (a2[1] - dy0)
        if bound(data, p2):
            qs.add(p2)
        dd = gcd(dx0, dy0)
        dx = dx0 // dd
        dy = dy0 // dd

        p = (a1[0] + dx), (a1[1] + dy)
        while bound(data, p):
            if p != a2:
                q2 += 1
                qs2.add(p)
            p = (p[0] + dx), (p[1] + dy)
        p = (a1[0] - dx), (a1[1] - dy)
        while bound(data, p):
            if p != a2:
                q2 += 1
                qs2.add(p)
            p = (p[0] - dx), (p[1] - dy)

        # axn = min(a1[0], a2[0])
        # ayn = min(a1[1], a2[1])
        # axx = max(a1[0], a2[0])
        # ayx = max(a1[1], a2[1])

        
        
print(q2, len(qs2))

for i, line in enumerate(data):
    for j, c in enumerate(line):
        if (i, j) in qs2:
            print('#', end='')
        else:
            print(c, end='')
    print()

