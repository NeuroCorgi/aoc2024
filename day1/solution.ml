open Core

module C = Map.Make(Int)

let counter
  = List.fold ~init:C.empty
      ~f:(fun acc n ->
        C.update acc n ~f:(function (Some a) -> a + 1 | None -> 1))

let transpose =
  List.fold ~init:([], [])
    ~f:(fun (lc, rc) (le, re) -> (le :: lc, re :: rc))

let () =
  let args = Sys.get_argv () in
  let lines = In_channel.read_lines (Array.get args 1) in
  let (lc, rc) =
    lines
    |> List.map
         ~f:(fun line -> line
                         |> String.split ~on:' '
                         |> (fun [l; _; _; r] -> (l, r))
                         |> Tuple2.map ~f:int_of_string)
    |> transpose
    |> Tuple2.map ~f:(List.sort ~compare:Int.compare)
  in
  let res1 =
    List.map2 ~f:(fun l r -> abs (l - r)) lc rc
    |> (fun (Ok r) -> r |> List.fold ~init:0 ~f:( + )) in
  let c = counter rc in
  let res2 =
    lc |>
    List.fold ~init:0
      ~f:(fun acc n -> acc + n * (match C.find c n with Some a -> a | None -> 0))
  in
  ignore (printf "\n%d\n%d\n" res1 res2)
