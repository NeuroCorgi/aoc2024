data ← ⍎¨ ⍉↑(' ' (≠⊆⊢) ⊢)¨ ⊃ ⎕NGET 'input' 1

rc ← ⊃↓1↑ data
lc ← ⊃↓1↓ data

⍝ Sort both columns
rc ← rc[⍋rc]
lc ← lc[⍋lc]

part1 ← +/|rc-lc
part2 ← +/((+/lc=⊢)×⊢)¨ rc
