import re

with open("input") as input, open("cmp", "w") as cmp:
    # regex = r".*((do\(\))?.*(mul\(\d{1,3},\d{1,3}\))*.*(don't\(\))*)*.*"

    regex = r"mul\((\d{1,3}),(\d{1,3})\)"

    matches = re.findall(regex, input.read())
    for match in matches:
        print(match, int(match[0]) * int(match[1]), file=cmp)
    # print(len(matches))

