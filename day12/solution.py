from functools import reduce
from collections import deque

with open("input") as file:
    grid = [list(line.strip()) for line in file.readlines()]

visited = [[0 for _ in range(len(grid[0]))] for _ in range(len(grid))]

def bound(p):
    x, y = p
    return 0 <= x < len(grid) and 0 <= y < len(grid[0])

def nb(x, y, bounded=True):
    if bounded:
        return (p for p in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)) if bound(p))
    else:
        return ((x, y, bound((x, y))) for (x, y) in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)))

def rotate_clockwise(dir):
    match dir:
        case (-1,  0): return ( 0,  1)
        case ( 0,  1): return ( 1,  0)
        case ( 1,  0): return ( 0, -1)
        case ( 0, -1): return (-1,  0)

def rotate_counterclockwise(dir):
    return rotate_clockwise(rotate_clockwise(rotate_clockwise(dir)))

def move(p, d):
    return (p[0] + d[0], p[1] + d[1])

def same(p1, p2):
    return bound(p2) and grid[p1[0]][p1[1]] == grid[p2[0]][p2[1]]

def outer_edge(pos):
    nedges = 0
    start = pos

    sdir = dir = (0, 1)
    first = True
    
    edge = {move(pos, rotate_counterclockwise(dir))}
    while first or not (pos == start and sdir == dir):
        if first: first = False
        if same(pos, move(pos, rotate_counterclockwise(dir))):
            dir = rotate_counterclockwise(dir)
            nedges += 1
            pos = move(pos, dir)
            continue
        if not same(pos, move(pos, dir)):
            edge.add(move(pos, rotate_counterclockwise(dir)))
            dir = rotate_clockwise(dir)
            nedges += 1
            continue
        edge.add(move(pos, rotate_counterclockwise(dir)))
        pos = move(pos, dir)
    return nedges, edge

def inner_edge(pos):
    nedges = 0
    start = pos

    sdir = dir = (0, -1)
    first = True
    
    edge = {pos}
    while first or not (pos == start and sdir == dir):
        if first: first = False
        if same(pos, move(pos, rotate_counterclockwise(dir))):
            dir = rotate_counterclockwise(dir)
            nedges += 1
            pos = move(pos, dir)
            continue
        if not same(pos, move(pos, dir)):
            dir = rotate_clockwise(dir)
            nedges += 1
            continue
        edge.add(pos)
        pos = move(pos, dir)
    return nedges, edge

def region(pos):
    cost = 0

    c = grid[pos[0]][pos[1]]
    area = 0
    perimiter = 0
    edges, es = outer_edge(pos)
    queue = deque([pos])

    edge = set()
    while len(queue):
        (x, y) = queue.popleft()
        if visited[x][y]: continue
        visited[x][y] = 1
        area += 1
        
        for (nx, ny, b) in nb(x, y, bounded=False):
            if not b or grid[nx][ny] != c:
                if b:
                    edge.add((nx, ny))
                perimiter += 1
            elif b:
                queue.append((nx, ny))

    # print(edge, es)
    inner_es = edge - es
    # print(inner_es)
    while len(inner_es):
        start = max(inner_es)
        ie, ies = inner_edge(start)
        # print(start, ie, ies)
        edges += ie
        inner_es -= ies

    # print(c, area, perimiter, edges, len(edge), edge - es)
    return area * edges

cost = sum(region((i, j)) for i, line in enumerate(grid) for j, c in enumerate(line) if not visited[i][j])
# for i, line in enumerate(grid):
#     for j, c in enumerate(line):
#         if visited[i][j]:
#             continue
#         cost += region((i, j))
print(cost)
        
