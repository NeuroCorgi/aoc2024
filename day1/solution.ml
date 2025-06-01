open Core

module C = Map.Make(Int)

let ( >> ) f g x = g (f x)
let uncurry f (x, y) = f x y

let counter
  = List.fold ~init:C.empty
      ~f:(fun acc n ->
        C.update acc n ~f:(function (Some a) -> a + 1 | None -> 1))

let data = List.(map ~f:(String.split ~on:' ' >> (fun [l; _; _; r] -> (l, r)) >> Tuple2.map ~f:int_of_string)
                 >> fold ~init:([], []) ~f:(fun (lc, rc) (le, re) -> (le :: lc, re :: rc)))

let part1 = List.(Tuple2.map ~f:(sort ~compare:Int.compare)
                  >> (uncurry map2 ~f:(fun l r -> abs (l - r)))
                  >> (fun (Ok r) -> r |> fold ~init:0 ~f:( + )))

(* let part2 = () *)

let () =
  (* let open String in *)
  let open List in
  let args = Sys.get_argv () in
  let lines = In_channel.read_lines (Array.get args 1) in
  let (lc, rc) =
    lines
    |> map
         ~f:(String.split ~on:' ' >> (fun [l; _; _; r] -> (l, r)) >> Tuple2.map ~f:int_of_string)
    |> fold ~init:([], []) ~f:(fun (lc, rc) (le, re) -> (le :: lc, re :: rc))
    |> Tuple2.map ~f:(sort ~compare:Int.compare)
  in
  let res1 = lines |> data |> part1 in
  let c = counter rc in
  let res2 =
    lc |>
    fold ~init:0
      ~f:(fun acc n -> acc + n * (match C.find c n with Some a -> a | None -> 0))
  in
  ignore (printf "\n%d\n%d\n" res1 res2)
