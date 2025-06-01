with open("cpy") as py, open("cml") as ml:
    for i, (l1, l2) in enumerate(zip(py.readlines(), ml.readlines())):
        if l1.strip() != l2.strip():
            print(i, l1.strip(), l2.strip())
