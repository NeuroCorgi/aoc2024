open Core

module type I = sig
  val input : string

  val part : [> `First | `Second ]
end

let ( >> ) =
  let compose f g x = g (f x) in
  compose

module Solution(Input : I) = struct
  type pos = { x : int64; y : int64 }
  
  type section =
    { a : pos
    ; b : pos
    ; p : pos
    }

  let pattern = Re.(compile (rep1 digit))

  let sections =
    let open Int64 in
    let shift = match Input.part with `First -> zero | `Second -> of_string "10000000000000" in
    Input.input 
    |> String.split ~on:'\n'
    |> List.group ~break:(fun _ -> String.is_empty)
    |> List.map ~f:String.concat
    |> List.drop_last_exn
    |> List.map ~f:(Re.matches pattern >> List.map ~f:(fun s -> Int64.of_string s))
    |> List.map ~f:(fun [a; b; c; d; e; f] -> { a={x=a; y=b}; b={x=c; y=d}; p={x=e+shift; y=f+shift} })

  (* module type M = sig *)
  (*   type t *)
  (*   val ( = ) : t -> t -> bool *)
  (*   val zero : t *)
  (*   val rem : t -> t -> t *)
  (* end *)

  (* let gcd (type i) (module Math : M with type t = i) (a : i) (b : i) : i = *)
  (*   let open Math in *)
  (*   let rec aux a b = *)
  (*     if b = zero then a else aux b (rem a b) *)
  (*   in *)
  (*   aux a b *)

  let res =
    let open Int64 in
    let tokens {a; b; p} =
      let num = p.x * b.y - b.x * p.y in
      let den = a.x * b.y - a.y * b.x in
      (* let g = gcd (module Int64) num den in *)
      (* let res = if g = den then *)
        (* (of_int 3) * num / den + (p.y - num / den * a.y) / b.y *)
                (* else zero *)
      (* in *)
      let ar = num / den in
      let br = (p.y - ar * a.y) / b.y in
      if ((ar * a.x + br * b.x = p.x) && (ar * a.y + br * b.y = p.y)) then
        (of_int 3) * ar + br
      else zero
      (* Printf.printf "%s %s %s\n" (to_string @@ ar) (to_string @@ br) (to_string res); *)
      (* res *)
    in
    sections
    |> List.map ~f:tokens
    |> List.sum (module Int64) ~f:Fn.id
  
end


let () =
  print_endline "";
  let args = Sys.get_argv () in
  let file = In_channel.read_all args.(1) in
  (* let module Part1 = *)
  (*   Solution( *)
  (*       struct *)
  (*         let input = file *)
  (*         let part = `First *)
  (*       end) *)
  (* in *)
  let module Part2 =
    Solution(
        struct
          let input = file
          let part = `Second
        end)
  in
  (* Printf.printf "part1: %s\n" (Int64.to_string Part1.res); *)
  Printf.printf "part2: %s\n" (Int64.to_string Part2.res)


