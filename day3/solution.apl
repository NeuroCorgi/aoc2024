data ← ⊃,/⊃ ⎕NGET 'input' 1

⎕ ← part1 ← +/'mul\(\d{1,3},\d{1,3}\)'⎕S{×/⍎¨(((⍕0,⍳9)∊⍨⊢)⊆⊢) ⍵.Match} ⊢ data

matches ← 'mul\(\d{1,3},\d{1,3}\)'⎕S{⊆ ⍵.Offsets (×/⍎¨(((⍕0,⍳9)∊⍨⊢)⊆⊢) ⍵.Match)} ⊢ data
prods ← (⊂((2⊃¨matches),0)) ⌷⍨¨(((≢⍴⊢)(↑(⊃¨matches)))⍳⊢)¨⍳≢data
mask ← { ((⍵ < 0) × 0) + ((⍵ > 0) × 1) + ((⍵ = 0) × ⍺) }\((('do()' ⍷ data) - ('don''t()' ⍷ data)))  ⍝ If only it was a left scan
⎕ ← part2 ← +/mask×prods  ⍝ This gives an incorrect result
