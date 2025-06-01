from dataclasses import dataclass
from typing import TypeVar, Optional
from itertools import compress, dropwhile, takewhile

# T = Type

@dataclass
class Node:
    id: Optional[int]
    # start: int
    len: int
    prev: Optional['Node']
    next: Optional['Node']

    def __str__(self) -> str:
        return f"Node(id={self.id}, len={self.len}, prev={'Node' if self.prev else 'None'}, next={'Node' if self.next else 'None'})"

def decompress(seq, selector):
    for el, s in zip(seq, selector):
        while s > 0:
            yield el
            s -= 1

def id_nums():
    i = 0
    while -42:
        yield i
        yield None
        i += 1

def formated(disk):
    d = dropwhile(lambda e: e >= 0, disk)
    return all(a is None for a in d)

def cleanup(node):
    while node is not None:
        if node.prev and node.prev.id == node.id:
            node = node.prev
            node.len += node.next.len
            node.next = node.next.next
            if node.next:
                node.next.prev = node
        if node.next and node.next.id == node.id:
            node.len += node.next.len
            node.next = node.next.next
            if node.next:
                node.next.prev = node
        node = node.next
        
with open("input_b") as file:
    ds = list(map(int, file.readline().strip()))

disk = list(decompress(id_nums(), ds))

ids = id_nums()
lens = iter(ds)

start = 0
first = pnode = Node(id=next(ids), len=next(lens), prev=None, next=None)
for id, l in zip(ids, lens):
    if l == 0: continue
    node = Node(id=id, len=l, prev=pnode, next=None)
    pnode.next = node
    pnode = node
cleanup(first)

last = first
while last.next is not None:
    last = last.next

print(first)
print(last)
print()

node = first
def print_list(first):
    node = first
    while node is not None:
        print(node)
        node = node.next

print()

node = last
while node is not None:
    if node.id is None:
        node = node.prev
        continue
    # cleanup(first)
    # print("Moving node:", node)
    
    free = first
    while free.id is not None or free.len < node.len:
        free = free.next
        if free == node:
            free = None
            break

    if free is not None:
        # print("Found free:", free)

        free.id = node.id
        node.id = None

        if free.len > node.len:
            fnext = free.next
            free.next = Node(id=None, len=free.len - node.len, prev=free, next=fnext)
            fnext.prev = free.next
            free.len = node.len
    node = node.prev
    # print_list(first)
    # print()

print(first)
print()

# node = first
# while node is not None:
#     print(node)
#     node = node.next

start = 0
sum = 0
node = first
while node is not None:
    if node.id is not None:
        for i in range(start, start + node.len):
            sum += i * node.id

    start += node.len
    node = node.next

print(sum)

# node = first
# while node is not None:
#     print(node)
#     node = node.next

# for j in range(1, len(disk)):
#     if formated(disk):
#         break
#     if disk[-j] == None: continue
    
#     for i in range(len(disk)):
#         if disk[i] == None and disk[-j] != None:
#             disk[i], disk[-j] = disk[-j], disk[i]
#             break

#     # print(disk)

# print(sum(i * d for i, d in enumerate(takewhile(lambda a: a >= 0, disk))))
# # print(disk)
