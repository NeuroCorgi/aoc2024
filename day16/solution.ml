open Core

module type I = sig
  val input : string
  val part  : [> `First | `Second]
end

module Pos = struct
  module Internal = struct
    type t = {x : int; y : int} [@@deriving equal, compare, show, sexp]
  end

  include Internal
  include Comparator.Make(Internal)
  include Comparable.Make(Internal)

  let add a b = {x=a.x + b.x; y=a.y + b.y}
  let ( + ) = add

  let rotate_cw {x; y} = {x=y; y= -x}
  let rotate_ccw {x; y} = {x= -y; y=x}
end

module Solution(Input : I) = struct
  let grid = String.split_lines Input.input |> List.map ~f:String.to_array |> Array.of_list

  let get pos = Pos.(grid.(pos.y).(pos.x))

  let height = Array.length grid
  let width = Array.length grid.(0)

  type dir = N | E | S | W [@@deriving compare, sexp]
  let pos_of_dir = function
    | N -> Pos.{x=0; y= -1}
    | E -> Pos.{x=1; y=0}
    | S -> Pos.{x=0; y=1}
    | W -> Pos.{x= -1; y=0}
  let dir_of_pos = function
    | Pos.{x=0; y= -1} -> N
    | Pos.{x=1; y=0} -> E
    | Pos.{x=0; y=1} -> S
    | Pos.{x= -1; y=0} -> W 
  
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
    ((!start_p, E), !end_p)

  let bound Pos.{x; y} =
    let in_range a b c = a <= b && b < c in
    (in_range 0 x width) && (in_range 0 y height)

  let neighbors (pos, dir) =
    let pd = pos_of_dir dir in    
    Pos.[ ((pos + pd, dir), 1)
        ; (let d = rotate_cw pd in ((pos + d, dir_of_pos d), 1001))
        ; (let d = rotate_ccw pd in ((pos + d, dir_of_pos d), 1001))
    ]
    |> List.filter ~f:(fun ((pos, _), _) -> bound pos && not (Char.equal (get pos) '#'))
    (* |> List.filter ~f:(fun p -> not (Char.equal (get p) '#')) *)

  
  module PosDir = struct
    module Dir = struct type t = dir [@@deriving compare, sexp] end
    
    include Tuple.Make(Pos)(Dir)
    include Tuple.Comparator(Pos)(struct include Dir;; include Comparator.Make(Dir) end)
    include Tuple.Comparable(Pos)(struct include Dir;; include Comparable.Make(Dir) end)
  end
  module PosSet = Set.Make(Pos)
  module PosMap = Map.Make(Pos)
  module PosDirSet = Set.Make(PosDir)
  module PosDirMap = Map.Make(PosDir)

  let print ?(marked=PosSet.empty) () =
    let open PosSet in
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

  let part1 () =
    let h (pos : Pos.t) =
      abs (pos.x - end_p.x) + abs (pos.y - end_p.y) + 1000
    in
    let lookup m p = PosDirMap.find m p |> Option.value ~default:Int.max_value in
    let openSet = PosDirSet.singleton start_p in
    let fScore  = PosDirMap.singleton start_p (h @@ fst start_p) in
    let gScore  = PosDirMap.singleton start_p 0 in
    let cameFrom = PosDirMap.empty in
    
    let rec reconstruct_path cameFrom path s =
      let open PosDirSet in
      match PosDirMap.find cameFrom s with
      | Some ps -> union_list (ps |> to_list |> List.map ~f:(fun p -> reconstruct_path cameFrom (add path s) p))
      | None -> path
    in
    let rec aux (openSet, fScore, gScore, cameFrom) =
      if PosDirSet.is_empty openSet then (-1, PosDirSet.empty)
      else
        let ((pos, _) as current, f) =
          PosDirSet.fold
            ~f:(fun ((p, f) as acc) n ->
              let nf = lookup fScore n in
              if nf < f then (n, nf) else acc)
            ~init:(start_p, Int.max_value)
            openSet
        in
        if Pos.equal pos end_p then (lookup gScore current,
                                     reconstruct_path cameFrom PosDirSet.empty current
                                    ) else
          let set = PosDirSet.remove openSet current in
          let cg = lookup gScore current in
          let nbs = neighbors current in
          let state =
            nbs
            |> List.fold
                 ~init:(set, fScore, gScore, cameFrom)
                 ~f:(fun (openSet, fScore, gScore, cameFrom as state) ((p, _) as n, d) ->
                   let ng = cg + d in
                   match compare ng (lookup gScore n) with
                   | q when q < 0 ->
                      let set = PosDirSet.add openSet n in
                      let nfScore = PosDirMap.update fScore n ~f:(Fn.const (ng + h p)) in
                      let ngScore = PosDirMap.update gScore n ~f:(Fn.const ng) in
                      let ncf = PosDirMap.update cameFrom n ~f:(function
                                    | None -> PosDirSet.singleton current
                                    | Some p ->
                                       PosDirSet.(add (filter p ~f:(fun p -> lookup gScore p <= ng)) current)) in
                      (set, nfScore, ngScore, ncf)
                   | 0 ->
                      let ncf = PosDirMap.update cameFrom n ~f:(function
                                    | None -> PosDirSet.singleton current
                                    | Some p ->
                                       PosDirSet.(add (filter p ~f:(fun p -> lookup gScore p <= ng)) current)) in
                      (openSet, fScore, gScore, ncf)
                   | _ ->
                     state
                 )
          in
          aux state
    in
    print_endline (Pos.show @@ fst start_p);
    print_endline (Pos.show end_p);
    print_endline "";
 
    let (a, paths) = aux (openSet, fScore, gScore, cameFrom) in
    let paths = paths |> PosDirSet.to_list |> List.map ~f:fst |> PosSet.of_list in
    (* let path = reconstruct_path pathMap PosSet.empty (PosSet.singleton end_p) in *)
    Printf.printf "Path length?: %d\n" (PosSet.length paths + 1);
    print ~marked:paths ();
    a

  let res = part1 ()
  
end

let () =
  print_endline "";
  let filename = (Sys.get_argv ()).(1) in
  let input = In_channel.read_all filename in
  let module S1 =
    Solution(
        struct
          let input = input
          let part = `First
        end)
  in
  Printf.printf "Answer: %d" S1.res
