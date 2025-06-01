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
end

module Solution(Input : I) = struct
  let height = 71
  let width = 71
  
  let bytes =
    String.split_lines Input.input
    |> List.map ~f:(fun p -> let [x; y] = String.split p ~on:',' |> List.map ~f:int_of_string in Pos.{x; y})

  let make_grid init = Array.init height ~f:(fun _ -> Array.init width ~f:(fun _ -> init))
  let grid =
    let grid = make_grid '.' in
    List.take (bytes) (match Input.part with | `First -> 1024 | `Second -> 0)
    |> List.iter ~f:(fun Pos.{x; y} -> grid.(y).(x) <- '#');
    grid
    
  let get pos = Pos.(grid.(pos.y).(pos.x))

  let start_p = Pos.{x=0; y=0}
  let end_p   = Pos.{x=width - 1; y=height - 1}

  let bound Pos.{x; y} =
    let in_range a b c = a <= b && b < c in
    (in_range 0 x width) && (in_range 0 y height)

  let neighbors ?diagonal pos =
    List.append
      Pos.[ ((pos + {x= -1; y= 0}), 1)
          ; ((pos + {x=0; y=1}), 1)
          ; ((pos + {x=0; y= -1}), 1)
          ; ((pos + {x=1; y=0}), 1)
    ]
      (if Option.is_some diagonal then
         Pos.[ ((pos + {x= -1; y= -1}), 1)
             ; ((pos + {x=1; y=1}), 1)
             ; ((pos + {x=1; y= -1}), 1)
             ; ((pos + {x= -1; y=1}), 1)
         ] else [])
    |> List.filter ~f:(fun ((pos), _) -> bound pos && not (Char.equal (get pos) '#'))

  module PosSet = Set.Make(Pos)
  module PosMap = Map.Make(Pos)

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
      abs (pos.x - end_p.x) + abs (pos.y - end_p.y)
    in
    let lookup m p = PosMap.find m p |> Option.value ~default:Int.max_value in
    let openSet = PosSet.singleton start_p in
    let fScore  = PosMap.singleton start_p (h start_p) in
    let gScore  = PosMap.singleton start_p 0 in
    let rec aux (openSet, fScore, gScore) =
      if PosSet.is_empty openSet then -1
      else
        let ((pos) as current, f) =
          PosSet.fold
            ~f:(fun ((p, f) as acc) n ->
              let nf = lookup fScore n in
              if nf < f then (n, nf) else acc)
            ~init:(start_p, Int.max_value)
            openSet
        in
        if Pos.equal pos end_p then (lookup gScore current) else
          let set = PosSet.remove openSet current in
          let cg = lookup gScore current in
          let nbs = neighbors current in
          let state =
            nbs
            |> List.fold
                 ~init:(set, fScore, gScore)
                 ~f:(fun (openSet, fScore, gScore as state) ((p) as n, d) ->
                   let ng = cg + d in
                   match compare ng (lookup gScore n) with
                   | q when q < 0 ->
                      let set = PosSet.add openSet n in
                      let nfScore = PosMap.update fScore n ~f:(Fn.const (ng + h p)) in
                      let ngScore = PosMap.update gScore n ~f:(Fn.const ng) in
                      (set, nfScore, ngScore)
                   | _ ->
                     state
                 )
          in
          aux state
    in
    print_endline (Pos.show start_p);
    print_endline (Pos.show end_p);
    print_endline "";
 
    let (a) = aux (openSet, fScore, gScore) in
    print ();
    string_of_int a

  type colour = T | W | R | B [@@deriving equal]
  let show_colour = function
    | T -> '.'
    | W -> 'O'
    | R -> '#'
    | B -> '@'

  type d = Non | Get of colour * Pos.t | Contr of Pos.t
  let part2 () =
    let grid = make_grid T in
    let print () =
      let pc = Out_channel.output_char stdout in
      for i = 0 to height - 1 do
        for j = 0 to width - 1 do
          pc (show_colour grid.(i).(j))
      done;
      pc '\n'
    done;
    in
    let nb p = neighbors ~diagonal:true p |> List.map ~f:fst in
    let propagate_color (pos : Pos.t) c =
      let c = grid.(pos.y).(pos.x) in
      (* Printf.printf "Color to change: %c\n" (show_colour c); *)
      let rec aux = function
        | [] -> None
        | (h : Pos.t) :: t ->
           match grid.(h.y).(h.x) with
           | T -> aux t
           | W ->
              (* Printf.printf "Coloring from white: %s\n" (Pos.show h); *)
              grid.(h.y).(h.x) <- c;
              aux (List.append t (nb h))
           | d when equal_colour d c ->
              aux t
           | _ -> Some pos
      in
      (* Printf.printf "N: %d\n" (List.length (nb pos)); *)
      aux (nb pos)
    in
    let take_color (pos : Pos.t) =
      List.fold (nb pos) ~init:Non ~f:(function
          | Non -> fun (p : Pos.t) -> (match grid.(p.y).(p.x) with
                                        | R -> Get (R, p)
                                        | B -> Get (B, p)
                                        | _ -> Non)
          | Get (c, _) as q -> fun (p : Pos.t) -> (match grid.(p.y).(p.x) with
                                                    | T | W -> q
                                                    | w when not (equal_colour c w) -> Contr pos
                                                    | _ -> q)
          | (Contr _) as c -> fun _ -> c)
    in

    let (Some q) =
      bytes
      |> List.fold ~init:None ~f:(function
             | (Some _) as p -> fun _ -> p
             | None ->
                fun (p : Pos.t) ->
                if p.x = width - 1 || p.y = 0 then
                  (grid.(p.y).(p.x) <- R;
                   propagate_color p R)
                else if p.x = 0 || p.y = height - 1 then
                  (grid.(p.y).(p.x) <- B;
                   propagate_color p B)
                else
                  (match take_color p with
                   | Non -> (grid.(p.y).(p.x) <- W; None)
                   | Get (c,_) -> (grid.(p.y).(p.x) <- c; propagate_color p c)
                   | Contr p -> Some p
           ))
    in
    print ();
    Pos.show q

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
