data ← ⊃⎕NGET '/Users/aleksandrpokatilov/Projects/Contests/Advent of Code/Year 2024/day8/input' 1
max ← ≢↑data
onGrid ← ((∧/max≥⊢)∧(∧/1≤⊢))

antennas ← ⍸↑ data ≠ '.'

groups ← (⊂(⊂antennas)⊃⍨¨⊢)⌸(⊂data)⊃⍨¨antennas
antinodes ← ∪ ⊃,/⊃¨ ( ,/ ∘ (onGrid¨⊆⊢) ∘ flatten ((~((∘.=)⍨∘⍳≢))×(∘.{(2×⍺)-⍵}⍨)) )¨ groups
⎕ ← part ← ≢antinodes

⎕ ← part1 ← +/(+/+/ ∘ ((~((∘.=)⍨∘⍳≢))×(∘.{((∧/12>⊢)∧(∧/0<⊢))(2×⍺)-⍵}⍨)))¨ (⊂(⊂antenas)⊃⍨¨⊢)⌸(⊂data)⊃⍨¨antenas

flatten ← ((×/⍴⊢)⍴⊢)

data ← ⊃⎕NGET '/Users/aleksandrpokatilov/Projects/Contests/Advent of Code/Year 2024/day8/input' 1
max ← ≢↑data
antennas ← ⍸↑ data ≠ '.'
⎕ ← part1 ← +/(+/+/ ∘ ((~((∘.=)⍨∘⍳≢))×(∘.{((∧/max>⊢)∧(∧/0<⊢))(2×⍺)-⍵}⍨)))¨ (⊂(⊂antennas)⊃⍨¨⊢)⌸(⊂data)⊃⍨¨antennas
