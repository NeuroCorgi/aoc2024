data ← ⍎¨¨ (' ' (≠⊆⊢) ⊢)¨ ⊃ ⎕NGET 'input' 1

drop ← ((↑,/)(~⊣=(⍳∘≢⊢))⊆⊢)
safe ← ((((∧/0<⊢)∨(∧/0>⊢))∧(∧/(1 2 3)∊⍨(|⊢)))2-/⊢)
parts ← ((⊂⊢)drop⍨¨(⍳1+≢))

⎕ ← part1 ← +/safe¨data
⎕ ← part2 ← +/(∨/safe¨∘parts)¨data
