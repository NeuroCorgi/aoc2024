from collections import deque

with open("input") as file:
    grid = [list(map(int, line.strip())) for line in file.readlines()]

heads = [(i, j) for i, line in enumerate(grid) for j, c in enumerate(line) if c == 0]
visited = [[None for _ in range(len(grid[0]))] for _ in range(len(grid))]

def bound(x, y):
    return 0 <= x < len(grid) and 0 <= y < len(grid[0])

def neighbours(x, y):
    return ((x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1) if dx * dy == 0 and dx != dy and bound(x + dx, y + dy))



def search(start, visited):
    pos, e = start
    # print(pos, e, grid[pos[0]][pos[1]])
    if e != grid[pos[0]][pos[1]]: return 0
    if grid[pos[0]][pos[1]] == 9:
        return 1
    
    if pos in visited:
        return 0

    vs = visited.copy()
    vs.add(pos)
    return sum(search((n, e + 1), vs) for n in neighbours(*pos))
    # for n in neighbours(*start):

# queue = deque(map(lambda p: (p, 0), heads))
# while len(queue) != 0:
#     (pos, e) = queue.popleft()

print(sum(search((head, 0), set()) for head in heads))
