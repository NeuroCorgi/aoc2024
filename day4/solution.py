with open("input") as input:
    input = [list(line) for line in input.readlines()]

# I believe this function was in python,
# but I don't remember where and under what name
def power(f, x):
    while -42:
        yield x
        x = f(x)

def inbound(b, p):
    return (0 <= p[0] < len(b) and 0 <= p[1] < len(b[0]))

def search(b, s, start, step):
    dx, dy = step
    return all(inbound(b, (x, y)) and c == b[x][y] for c, (x, y) in zip(s, power(lambda p: (p[0] + dx, p[1] + dy), start)))

starts1 = [(i, j) for i, line in enumerate(input) for j, char in enumerate(line) if char == 'X']
starts2 = [(i, j) for i, line in enumerate(input) for j, char in enumerate(line) if char == 'M']

print(sum(1 for s in starts1 for dx in (-1, 0, 1) for dy in (-1, 0, 1) if not (dx == dy == 0) and search(input, 'XMAS', s, (dx, dy))))

boxes = [(min(x, x + 2 * dx), min(y, y + 2 * dy)) for (x, y) in starts2 for dx in (-1, 0, 1) for dy in (-1, 0, 1) if (dx * dy != 0) and search(input, 'MAS', (x, y), (dx, dy))]

print(len(boxes) - len(set(boxes)))
