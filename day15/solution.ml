open Core

module type I = sig
  val input : string
  val part  : [> `First | `Second]
end

module Pos = struct
  type t = {x : int; y : int}

  let add a b = {x=a.x+b.x; y=a.y+b.y}
  let ( + ) = add

  let mult a b = {x=a * b.x; y=a * b.y}
  let ( * ) = mult
end

module type Part = sig val move : Pos.t -> Pos.t -> Pos.t end

module Part1(Grid : sig val grid : char array array end) : Part = struct
  let grid = Grid.grid

  let boxes_ahead pos dir =
    let move p = Pos.(p + dir) in
    let get (pos : Pos.t) = grid.(pos.y).(pos.x) in
    let from = ref (move pos) in
    let count = ref 0 in
    while Char.equal (get !from) 'O' do
      from := move !from;
      count := !count + 1
    done;
    !count

  let move pos dir =
    let nb = boxes_ahead pos dir in
    let dest = Pos.(Int.(nb + 1) * dir + pos) in
    if Char.equal grid.(dest.y).(dest.x) '#' then
      pos
    else
      begin
        for i = nb downto 0 do
          let p = Pos.(i * dir + pos) in
          let np = Pos.(dir + p) in
          grid.(np.y).(np.x) <- grid.(p.y).(p.x);
          grid.(p.y).(p.x) <- '.'
        done;
        Pos.(pos + dir)
      end
end

module Part2(Grid : sig val grid : char array array end) : Part = struct
  let grid = Grid.grid

  let get (pos : Pos.t) = grid.(pos.y).(pos.x)
  let get_box (pos : Pos.t) =
    match get pos with
    | '[' -> (pos, Pos.{pos with x=Int.(pos.x+1)})
    | ']' -> (Pos.{pos with x=pos.x-1}, pos)

  let rec can_move pos dir =
    match get pos with
    | '.' -> true
    | '#' -> false
    | box ->
       let (left, right) = get_box pos in
       match dir with
       | Pos.{y=0; x=x} when x < 0 -> can_move Pos.(left + dir) dir
       | Pos.{y=0; x=x}  -> can_move Pos.(right + dir) dir
       | Pos.{x=0; _} -> can_move Pos.(left + dir) dir && can_move Pos.(right + dir) dir

  let rec move_next pos dir =
    match get pos with
    | '.' | '#' -> ()
    | box ->
       let (left, right) = get_box pos in
       match dir with
       | Pos.{x=0; y=dy} ->
          let nl = Pos.(left + dir) in
          let nr = Pos.(right + dir) in
          move_next nl dir;
          move_next nr dir;
          grid.(nl.y).(nl.x) <- grid.(left.y).(left.x);
          grid.(nr.y).(nr.x) <- grid.(right.y).(right.x);
          grid.(left.y).(left.x) <- '.';
          grid.(right.y).(right.x) <- '.'
       | Pos.{x=dx; y=0} when dx < 0 ->
            let y = left.y in
            move_next Pos.(left + dir) dir;
            grid.(y).(left.x + dx) <- grid.(y).(left.x);
            grid.(y).(left.x) <- grid.(y).(right.x);
            grid.(y).(right.x) <- '.'
       | Pos.{x=dx; y=0} ->
            let y = right.y in
            move_next Pos.(right + dir) dir;
            grid.(y).(right.x + dx) <- grid.(y).(right.x);
            grid.(y).(right.x) <- grid.(y).(left.x);
            grid.(y).(left.x) <- '.'
  
  let move pos dir =
    let next = Pos.(pos + dir) in
    if can_move next dir then
      begin
        move_next next dir;
        grid.(next.y).(next.x) <- grid.(pos.y).(pos.x);
        grid.(pos.y).(pos.x) <- '.';
        Pos.(pos + dir)
      end
    else
      pos
end

module Solution(Input : I) = struct

  let [grid_str; commands] =
    Re.(split (compile (str "\n\n")) Input.input)
  let grid = String.split_lines grid_str |> List.map ~f:String.to_array |> Array.of_list

  let height = Array.length grid
  let width  = Array.length grid.(0)

  let start () =
    let start = ref Pos.{x=0; y=0} in
    for i = 0 to height - 1 do
      for j = 0 to (Array.length grid.(0)) - 1 do
        if Char.equal grid.(i).(j) '@' then
          start := Pos.{x=j; y=i}
      done
    done;
    !start

  let print () =
    let pc = Out_channel.output_char stdout in
    for i = 0 to height - 1 do
      for j = 0 to (Array.length grid.(0)) - 1 do
        pc grid.(i).(j)
      done;
      pc '\n';
    done;
    Out_channel.flush stdout

  let dir_of_char = function
    | '<' -> Pos.{x= -1; y=  0}
    | '^' -> Pos.{x=  0; y= -1}
    | '>' -> Pos.{x=  1; y=  0}
    | 'v' -> Pos.{x=  0; y=  1}
    | _ -> failwith "unreachable"

  let move (module P : Part) pos c =
    if Char.equal c '\n' then pos
    else
      P.move pos (dir_of_char c)

  let execute (module P : Part) =
    String.fold commands ~init:(start ()) ~f:(fun pos dir -> move (module P) pos dir)
    |> ignore

  let gps char =
    let sum = ref 0 in
    for i = 0 to height - 1 do
      for j = 0 to (Array.length grid.(0)) - 1 do
        if Char.equal grid.(i).(j) char then
          sum := !sum + (100 * i + j)
      done
    done;
    !sum
    

  let part1 () =
    let module P1 = Part1(struct let grid = grid end) in
    execute (module P1);
    print ();
    gps 'O'

  let part2 () =
    for i = 0 to height - 1 do
      let row = Array.copy grid.(i) in
      grid.(i) <- Array.init (2 * width) ~f:(fun j ->
                      match row.(j / 2) with
                      | '@' when j mod 2 = 0 -> '@'
                      | '@' -> '.'
                      | 'O' when j mod 2 = 0 -> '['
                      | 'O' -> ']'
                      | c -> c)
    done;
    let module P2 = Part2(struct let grid = grid end) in
    print ();
    execute (module P2);
    print ();
    gps '['
  
  let res =
    match Input.part with
    | `First -> part1 ()
    | `Second -> part2 ()


end

let () =
  print_endline "";
  let argv = Sys.get_argv () in
  let input = In_channel.read_all argv.(1) in
  let module Result =
    Solution(
        struct
          let input = input
          let part = `Second
        end)
  in
  Printf.printf "Result: %d" Result.res;
  ()
