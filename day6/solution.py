with open("input") as input:
    b = [list(line.strip()) for line in input.readlines()]

print(len(b), len(b[0]))
start = next((i, j) for i, line in enumerate(b) for j, c in enumerate(line) if c == '^')
print(start)

def move(pos, dir):
    match dir:
        case 0: return (pos[0] - 1, pos[1])
        case 1: return (pos[0], pos[1] + 1)
        case 2: return (pos[0] + 1, pos[1])
        case 3: return (pos[0], pos[1] - 1)

def step(board, pos, dir):
    (x, y) = move(pos, dir)
    if not ((0 <= x < len(board)) and (0 <= y < len(board[0]))):
        return None, True

    if board[x][y] == '#':
        return step(board, pos, (dir + 1) % 4)

    return ((x, y), dir), False

def follow(board, start):
    visited = set()
    pos = start
    
    while pos not in visited:
        visited.add(pos)
        
        pos, exited = step(board, *pos)
        if exited: return False
        # try:
        #     if board[npos[0][0]][npos[0][1]] == '#':
        #         pos = (pos[0], (pos[1] + 1) % 4)
        #     else:
        #         pos = npos
        # except IndexError:
        #     return False
        
    return True

# while pos not in visited:
start = (start, 0)
visited = set()

pos = start
while -42:
    visited.add(pos[0])
    pos, exited = step(b, *pos)

    if exited:
        break

print(len(visited))

# c = sum(1 for (pos, dir) in visited if (pos, (dir + 1) % 4) in visited)
c = 0
cs = set()
for (x, y) in visited:
    if (x, y) == start[0]: continue

    e = b[x][y]
    
    b[x][y] = '#'

    if follow(b, start):
        cs.add((x, y))
        c += 1

    b[x][y] = e

print("C:", c, len(cs))
