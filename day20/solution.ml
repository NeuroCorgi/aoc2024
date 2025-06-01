open Core

module type I = sig
  val input : string
  val part  : [> `First | `Second]
end

module Pos = struct

  type t = {x : int; y : int} [@@deriving equal, compare, show, sexp]

  let add a b = {x=a.x + b.x; y=a.y + b.y}
  let ( + ) = add

  let sub a b = {x=a.x - b.x; y=a.y - b.y}
  let ( - ) = sub

  let mult a b = {x=a * b.x; y=a * b.y}
  let ( * ) = mult
end

module Solution(Input : I) = struct

  let grid = String.split_lines Input.input |> List.map ~f:String.to_array |> Array.of_list
    
  let get pos = Pos.(grid.(pos.y).(pos.x))

  let height = Array.length grid
  let width = Array.length grid.(0)

  let (start_p, end_p) =
    let start_p = ref Pos.{x=0; y=0} in
    let end_p = ref Pos.{x=0; y=0} in
    for i = 0 to height - 1 do
      for j = 0 to width - 1 do
        let p = Pos.{x=j; y=i} in
        match get p with
        | 'S' -> start_p := p
        | 'E' -> end_p := p
        | _ -> ()
      done
    done;
    (!start_p, !end_p)

  let bound Pos.{x; y} =
    let in_range a b c = a <= b && b < c in
    (in_range 0 x width) && (in_range 0 y height)

  let neighbors ?(wall=false) pos =
      Pos.[ (pos + {x= -1; y=  0})
          ; (pos + {x=  0; y=  1})
          ; (pos + {x=  0; y= -1})
          ; (pos + {x=  1; y=  0})
      ]
    |> List.filter ~f:(fun (pos) -> bound pos && (wall || not (Char.equal (get pos) '#')))

  module PosSet = Set.Make(Pos)
  module PosMap = Map.Make(Pos)
  module IntMap = Map.Make(Int)

  let print ?(marked=PosMap.empty) () =
    let open PosMap in
    let pc = Out_channel.output_char stdout in
    for i = 0 to height - 1 do
      for j = 0 to width - 1 do
        let p = Pos.{x=j; y=i} in
        if mem marked p then
          pc 'O'
        else
          pc (get p)
      done;
      pc '\n'
    done;
    ()

  let area r pos =
    let rec aux set queue = function
      | 0 -> set |> PosSet.filter ~f:(fun p -> not (Char.equal (get p) '#'))
      | n ->
         let front =
           queue
           |> List.filter ~f:(fun p -> Char.equal (get p) '#')
           |> List.concat_map  ~f:(neighbors ~wall:true)
           |> List.filter ~f:(fun p -> not (PosSet.mem set p))
         in
         aux (List.fold front ~init:set ~f:PosSet.add) front (n - 1)
    in
    aux PosSet.empty (neighbors ~wall:true pos) (r - 1)
    |> PosSet.to_list

  let path =
    let rec path vis pos i =
      if Pos.equal pos end_p then (PosMap.add_exn vis ~key:end_p ~data:i) else
        let [next] = neighbors pos |> List.filter ~f:(fun p -> not (PosMap.mem vis p)) in
        path (PosMap.add_exn vis ~key:pos ~data:i) next (i + 1)
    in
    path PosMap.empty start_p 0

  let len = PosMap.length path

  let part1 () =
    let cheats = PosMap.mapi path
              ~f:List.(fun ~key ~data ->
        area 2 key
        |> map ~f:(fun w -> (PosMap.find_exn path w) - data - 2)
        |> filter ~f:(( < ) 0))
    in
    let useful_cheats = PosMap.fold cheats ~init:0
                          ~f:(fun  ~key ~data sum ->
                            sum + (data |> List.filter ~f:(( <= ) 100) |> List.length)) in
    string_of_int useful_cheats

  let part2 () =
    let cheats = PosMap.mapi path
                   ~f:List.(fun ~key ~data ->
        area 20 key
        |> map ~f:(fun w -> (PosMap.find_exn path w) - data - 2)
        |> filter ~f:(( < ) 0))
    in
    let useful_cheats = PosMap.fold cheats ~init:0
                          ~f:(fun  ~key ~data sum ->
                            sum + (data |> List.filter ~f:(( <= ) 100) |> List.length)) in
    string_of_int useful_cheats

  let res =
    match Input.part with
    | `First -> part1 ()
    | `Second -> part2 ()
  
  
end

let () =
  print_endline "";
  let filename = (Sys.get_argv ()).(1) in
  let input = In_channel.read_all filename in
  let module S1 =
    Solution(struct let input = input;; let part = `First end)
  in
  let module S2 =
    Solution(struct let input = input;; let part = `Second end)
  in
  Printf.printf "Answer: %s\n" S1.res;
  Printf.printf "Answer: %s\n" S2.res
