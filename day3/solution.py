from itertools import takewhile

def process(p: str, cond=False) -> int:
    def comp(s: int):
        if p[s:s+4] != "mul(":
            num = ''.join(takewhile(str.isdigit, p[s:]))
            if len(num) > 0: return (int(num), s + len(num))
            return None
        s += 4

        left = comp(s)
        if left == None: return None
        (lhs, s) = left
        
        if p[s] != ',': return None
        s += 1
        
        right = comp(s)
        if right == None: return None
        (rhs, s) = right

        if p[s] != ')': return None
        s += 1

        return (lhs * rhs, s)

    sum = 0
    s = 0
    en = True

    while -42:
        s1 = p.find("mul(", s)
        s2 = p.find("don't()", s)
        s3 = p.find("do()", s)

        if all(s == -1 for s in (s1, s2, s3)): break

        s1 = ('m', len(p) if s1 == -1 else s1)
        s2 = ('d', len(p) if s2 == -1 else s2)
        s3 = ('e', len(p) if s3 == -1 else s3)

        act = min((s1, s2, s3), key=lambda c: c[1])

        match act[0]:
            case 'm' if en:
                c = comp(act[1])
                if c is not None:
                    sum += c[0]
            case 'd' if cond:
                en = False
            case 'e' if cond:
                en = True

        s = act[1] + 1

    return sum

with open("input") as input:
    input = input.read()
    print(process(input))
    print(process(input, True))
    # print(compute("mul(mul(mul(1,2),3),4)"))
