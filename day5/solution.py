from collections import defaultdict
from itertools import accumulate

with open("input") as input:
    orders, updates = map(lambda line: line.strip().split("\n"), input.read().split("\n\n"))

orders = [tuple(map(int, line.strip().split("|"))) for line in orders]
updates = [list(map(int, line.strip().split(","))) for line in updates]

preord = defaultdict(set)
postord = defaultdict(set)
for (l, r) in orders:
    preord[l].add(r)
    postord[r].add(l)

post_up = list(map(lambda u: list(accumulate(map(lambda x: {x}, u[:0:-1]), lambda a, b: set.union(a, b)))[::-1] + [set()], updates))

def safe(u, post):
    return all(len(p - preord[i]) == 0 for p, i in zip(post, u))

s = sum(u[len(u) // 2] for u, post in zip(updates, post_up) if safe(u, post))
print(s)

for i in range(len(updates)):
    c = False
    u = updates[i]
    post = post_up[i]
    while not safe(u, post):
        for j in range(len(u)):
            diff = post[j] - preord[u[j]]
            if len(diff) != 0:
                ind = max(u.index(e) for e in diff)
                e = u[j]
                del u[j]
                u.insert(ind, e)
                post = list(accumulate(map(lambda x: {x}, u[:0:-1]), lambda a, b: set.union(a, b)))[::-1] + [set()]
                c = True
                break
    if c:
        s += u[len(u)//2]

print(s)
