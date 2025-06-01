open Core

module type I = sig
  val input : string

  val part : [> `First | `Second ]
end

module Pos = struct
  type t = {x : int; y : int} [@@deriving equal, compare, sexp]
end
module PosComparator = struct
  include Pos
  include Comparator.Make(Pos)
end

let ( >> ) =
  let compose f g x = g (f x) in
  compose

module Solution(Input : I) = struct

  let width = 101
  let height = 103
  (* let width = 11 *)
  (* let height = 7 *)

  type robot =
    { vel : Pos.t
    ; mutable pos : Pos.t
    }

  let modulus a b =
    if b = 0 then
      failwith "Division by zero"
    else
      let result = a mod b in
      if result < 0 then
        result + b
      else
        result

  let pattern = Re.(compile (seq [opt(char '-'); rep1 digit]))

  let robots =
    Input.input
    |> String.split_lines
    |> List.map
         ~f:(Re.matches pattern
             >> List.map ~f:int_of_string
             >> (fun [px; py; vx; vy] -> { vel={x=vx; y=vy}; pos={x=px; y=py} })
         )

  let print robots =
    let open List in
    let robot_poss =
      robots
      >>| (fun r -> r.pos)
      |> Set.of_list (module PosComparator)
    in
    let pc = Out_channel.output_char stdout in
    for j = 0 to height do
      for i = 0 to width do
        if Set.mem robot_poss {x=i; y=j} then
          pc '@'
        else
          pc '.'
      done;
      pc '\n'
    done

  let move r =
    let nx = modulus (r.pos.x + r.vel.x) width in
    let ny = modulus (r.pos.y + r.vel.y) height in
    {r with pos={x=nx; y=ny} }

  let step = List.map ~f:move

  type quadrants = {q1 : int; q2 : int; q3 : int; q4 : int}
  let part1 () =
    let compare' a b =
      match compare a b with
      | n when n < 0 -> `Lt
      | n when n > 0 -> `Gt
      | _ -> `Eq
    in
    let rec aux = function
      | 0 -> Fn.id
      | n -> step >> aux (n - 1)
    in
    let qs =
      aux 100 robots
      |> List.fold
           ~init:{q1=0; q2=0; q3=0; q4=0}
           ~f:(fun qs r ->
             match (compare' r.pos.x (width / 2), compare' r.pos.y (height / 2)) with
             | (`Lt, `Lt) -> {qs with q1=qs.q1 + 1}
             | (`Lt,  `Gt) -> {qs with q2=qs.q2 + 1}
             | (`Gt, `Lt) -> {qs with q3=qs.q3 + 1}
             | (`Gt,  `Gt) -> {qs with q4=qs.q4 + 1}
             | _ -> qs
           )
    in
    Printf.printf "%d %d %d %d\n" qs.q1 qs.q2 qs.q3 qs.q4;
    qs.q1 * qs.q2 * qs.q3 * qs.q4

  let part2 () =
    let rec aux n rs =
      let robot_poss =
        rs
        |> List.map ~f:(fun r -> r.pos)
        |> Set.of_list (module PosComparator)
      in
      let groups =
        Set.group_by robot_poss ~equiv:(fun a b -> a.x = b.x)
        |> List.map ~f:Set.length
        |> List.exists ~f:(fun l -> l > 30)
      in
      (* let y = 0 in *)
      match groups with
      (* match List.for_all ~f:Fn.id (List.map ~f:(fun x -> Set.mem robot_poss {x; y}) @@ List.init width ~f:Fn.id) with *)
      | true ->
         print rs;
         Out_channel.flush stdout;
         let c = In_channel.(input_line_exn stdin) in
         if String.equal c "c" then
           aux (n + 1) (step rs)
         else
           n
      | false -> aux (n + 1) (step rs)
    in
    aux 0 robots

  let res = match Input.part with
    | `First  -> part1 ()
    | `Second -> part2 ()
  
end

let () =
  print_endline "";
  let args = Sys.get_argv () in
  let file = In_channel.read_all args.(1) in
  let module Part1 =
    Solution(
        struct
          let input = file
          let part = `Second
        end)
  in
  (* let module Part2 = *)
  (*   Solution( *)
  (*       struct *)
  (*         let input = file *)
  (*         let part = `Second *)
  (*       end) *)
  (* in *)
  Printf.printf "Answer: %d\n" (Part1.res);
  (* Printf.printf "part2: %s\n" (Part2.res)   *)
