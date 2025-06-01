(declare-const a1 (_ BitVec 64))

(declare-const b11 (_ BitVec 64))
(declare-const b12 (_ BitVec 64))
(declare-const b13 (_ BitVec 64))
(declare-const c1 (_ BitVec 64))

(declare-const a2 (_ BitVec 64))

(assert (= b11 (bvxor (bvand a1 #x0000000000000007) #x0000000000000002)))
(assert (= c1 (bvlshr a1 b11)))
(assert (= b12 (bvxor b11 #x0000000000000007)))
(assert (= b13 (bvxor b12 c1)))
(assert (= (bvand b13 #x0000000000000007) #x0000000000000002))
(assert (= a2 (bvlshr a1 #x0000000000000003)))

(declare-const b21 (_ BitVec 64))
(declare-const b22 (_ BitVec 64))
(declare-const b23 (_ BitVec 64))
(declare-const c2 (_ BitVec 64))

(declare-const a3 (_ BitVec 64))

(assert (= b21 (bvxor (bvand a2 #x0000000000000007) #x0000000000000002)))
(assert (= c2 (bvlshr a2 b21)))
(assert (= b22 (bvxor b21 #x0000000000000007)))
(assert (= b23 (bvxor b22 c2)))
(assert (= (bvand b23 #x0000000000000007) #x0000000000000004))
(assert (= a3 (bvlshr a2 #x0000000000000003)))

(declare-const b31 (_ BitVec 64))
(declare-const b32 (_ BitVec 64))
(declare-const b33 (_ BitVec 64))
(declare-const c3 (_ BitVec 64))

(declare-const a4 (_ BitVec 64))

(assert (= b31 (bvxor (bvand a3 #x0000000000000007) #x0000000000000002)))
(assert (= c3 (bvlshr a3 b31)))
(assert (= b32 (bvxor b31 #x0000000000000007)))
(assert (= b33 (bvxor b32 c3)))
(assert (= (bvand b33 #x0000000000000007) #x0000000000000001))
(assert (= a4 (bvlshr a3 #x0000000000000003)))

(declare-const b41 (_ BitVec 64))
(declare-const b42 (_ BitVec 64))
(declare-const b43 (_ BitVec 64))
(declare-const c4 (_ BitVec 64))

(declare-const a5 (_ BitVec 64))

(assert (= b41 (bvxor (bvand a4 #x0000000000000007) #x0000000000000002)))
(assert (= c4 (bvlshr a4 b41)))
(assert (= b42 (bvxor b41 #x0000000000000007)))
(assert (= b43 (bvxor b42 c4)))
(assert (= (bvand b43 #x0000000000000007) #x0000000000000002))
(assert (= a5 (bvlshr a4 #x0000000000000003)))

(declare-const b51 (_ BitVec 64))
(declare-const b52 (_ BitVec 64))
(declare-const b53 (_ BitVec 64))
(declare-const c5 (_ BitVec 64))

(declare-const a6 (_ BitVec 64))

(assert (= b51 (bvxor (bvand a5 #x0000000000000007) #x0000000000000002)))
(assert (= c5 (bvlshr a5 b51)))
(assert (= b52 (bvxor b51 #x0000000000000007)))
(assert (= b53 (bvxor b52 c5)))
(assert (= (bvand b53 #x0000000000000007) #x0000000000000007))
(assert (= a6 (bvlshr a5 #x0000000000000003)))

(declare-const b61 (_ BitVec 64))
(declare-const b62 (_ BitVec 64))
(declare-const b63 (_ BitVec 64))
(declare-const c6 (_ BitVec 64))

(declare-const a7 (_ BitVec 64))

(assert (= b61 (bvxor (bvand a6 #x0000000000000007) #x0000000000000002)))
(assert (= c6 (bvlshr a6 b61)))
(assert (= b62 (bvxor b61 #x0000000000000007)))
(assert (= b63 (bvxor b62 c6)))
(assert (= (bvand b63 #x0000000000000007) #x0000000000000005))
(assert (= a7 (bvlshr a6 #x0000000000000003)))

(declare-const b71 (_ BitVec 64))
(declare-const b72 (_ BitVec 64))
(declare-const b73 (_ BitVec 64))
(declare-const c7 (_ BitVec 64))

(declare-const a8 (_ BitVec 64))

(assert (= b71 (bvxor (bvand a7 #x0000000000000007) #x0000000000000002)))
(assert (= c7 (bvlshr a7 b71)))
(assert (= b72 (bvxor b71 #x0000000000000007)))
(assert (= b73 (bvxor b72 c7)))
(assert (= (bvand b73 #x0000000000000007) #x0000000000000000))
(assert (= a8 (bvlshr a7 #x0000000000000003)))

(declare-const b81 (_ BitVec 64))
(declare-const b82 (_ BitVec 64))
(declare-const b83 (_ BitVec 64))
(declare-const c8 (_ BitVec 64))

(declare-const a9 (_ BitVec 64))

(assert (= b81 (bvxor (bvand a8 #x0000000000000007) #x0000000000000002)))
(assert (= c8 (bvlshr a8 b81)))
(assert (= b82 (bvxor b81 #x0000000000000007)))
(assert (= b83 (bvxor b82 c8)))
(assert (= (bvand b83 #x0000000000000007) #x0000000000000003))
(assert (= a9 (bvlshr a8 #x0000000000000003)))

(declare-const b91 (_ BitVec 64))
(declare-const b92 (_ BitVec 64))
(declare-const b93 (_ BitVec 64))
(declare-const c9 (_ BitVec 64))

(declare-const a10 (_ BitVec 64))

(assert (= b91 (bvxor (bvand a9 #x0000000000000007) #x0000000000000002)))
(assert (= c9 (bvlshr a9 b91)))
(assert (= b92 (bvxor b91 #x0000000000000007)))
(assert (= b93 (bvxor b92 c9)))
(assert (= (bvand b93 #x0000000000000007) #x0000000000000001))
(assert (= a10 (bvlshr a9 #x0000000000000003)))

(declare-const b101 (_ BitVec 64))
(declare-const b102 (_ BitVec 64))
(declare-const b103 (_ BitVec 64))
(declare-const c10 (_ BitVec 64))

(declare-const a11 (_ BitVec 64))

(assert (= b101 (bvxor (bvand a10 #x0000000000000007) #x0000000000000002)))
(assert (= c10 (bvlshr a10 b101)))
(assert (= b102 (bvxor b101 #x0000000000000007)))
(assert (= b103 (bvxor b102 c10)))
(assert (= (bvand b103 #x0000000000000007) #x0000000000000007))
(assert (= a11 (bvlshr a10 #x0000000000000003)))

(declare-const b111 (_ BitVec 64))
(declare-const b112 (_ BitVec 64))
(declare-const b113 (_ BitVec 64))
(declare-const c11 (_ BitVec 64))

(declare-const a12 (_ BitVec 64))

(assert (= b111 (bvxor (bvand a11 #x0000000000000007) #x0000000000000002)))
(assert (= c11 (bvlshr a11 b111)))
(assert (= b112 (bvxor b111 #x0000000000000007)))
(assert (= b113 (bvxor b112 c11)))
(assert (= (bvand b113 #x0000000000000007) #x0000000000000004))
(assert (= a12 (bvlshr a11 #x0000000000000003)))

(declare-const b121 (_ BitVec 64))
(declare-const b122 (_ BitVec 64))
(declare-const b123 (_ BitVec 64))
(declare-const c12 (_ BitVec 64))

(declare-const a13 (_ BitVec 64))

(assert (= b121 (bvxor (bvand a12 #x0000000000000007) #x0000000000000002)))
(assert (= c12 (bvlshr a12 b121)))
(assert (= b122 (bvxor b121 #x0000000000000007)))
(assert (= b123 (bvxor b122 c12)))
(assert (= (bvand b123 #x0000000000000007) #x0000000000000001))
(assert (= a13 (bvlshr a12 #x0000000000000003)))

(declare-const b131 (_ BitVec 64))
(declare-const b132 (_ BitVec 64))
(declare-const b133 (_ BitVec 64))
(declare-const c13 (_ BitVec 64))

(declare-const a14 (_ BitVec 64))

(assert (= b131 (bvxor (bvand a13 #x0000000000000007) #x0000000000000002)))
(assert (= c13 (bvlshr a13 b131)))
(assert (= b132 (bvxor b131 #x0000000000000007)))
(assert (= b133 (bvxor b132 c13)))
(assert (= (bvand b133 #x0000000000000007) #x0000000000000005))
(assert (= a14 (bvlshr a13 #x0000000000000003)))

(declare-const b141 (_ BitVec 64))
(declare-const b142 (_ BitVec 64))
(declare-const b143 (_ BitVec 64))
(declare-const c14 (_ BitVec 64))

(declare-const a15 (_ BitVec 64))

(assert (= b141 (bvxor (bvand a14 #x0000000000000007) #x0000000000000002)))
(assert (= c14 (bvlshr a14 b141)))
(assert (= b142 (bvxor b141 #x0000000000000007)))
(assert (= b143 (bvxor b142 c14)))
(assert (= (bvand b143 #x0000000000000007) #x0000000000000005))
(assert (= a15 (bvlshr a14 #x0000000000000003)))

(declare-const b151 (_ BitVec 64))
(declare-const b152 (_ BitVec 64))
(declare-const b153 (_ BitVec 64))
(declare-const c15 (_ BitVec 64))

(declare-const a16 (_ BitVec 64))

(assert (= b151 (bvxor (bvand a15 #x0000000000000007) #x0000000000000002)))
(assert (= c15 (bvlshr a15 b151)))
(assert (= b152 (bvxor b151 #x0000000000000007)))
(assert (= b153 (bvxor b152 c15)))
(assert (= (bvand b153 #x0000000000000007) #x0000000000000003))
(assert (= a16 (bvlshr a15 #x0000000000000003)))

(declare-const b161 (_ BitVec 64))
(declare-const b162 (_ BitVec 64))
(declare-const b163 (_ BitVec 64))
(declare-const c16 (_ BitVec 64))

(declare-const a17 (_ BitVec 64))

(assert (= b161 (bvxor (bvand a16 #x0000000000000007) #x0000000000000002)))
(assert (= c16 (bvlshr a16 b161)))
(assert (= b162 (bvxor b161 #x0000000000000007)))
(assert (= b163 (bvxor b162 c16)))
(assert (= (bvand b163 #x0000000000000007) #x0000000000000000))
(assert (= a17 (bvlshr a16 #x0000000000000003)))

(assert (= a17 #x0000000000000000))

(minimize a1)

(check-sat)
(get-objectives)
