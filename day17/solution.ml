open Core

module type I = sig
  val input : string

  val part : [> `First | `Second ]
end

(* module Symb = struct *)

(*   type op = *)
(*     | Source *)
(*     | Xor *)
(*   type node = { *)
(*       mutable connections : node list; *)
(*       op : op; *)
(*       value : int64 option *)
(*     } *)
  
(*   type t = *)
(*     | Lit of int *)
(*     | Var of string *)
(*     | Exp of t * op * t *)
(*   (\* and op = *\) *)
(*   (\*   | Pow *\) *)
(*   (\*   | Mul *\) *)
(*   (\*   | UnAnd *\) *)
(*   (\*   | Xor *\) *)

(*   (\* let lit a = Lit a *\) *)
(*   (\* let ( ^ ) = fun a b -> Exp (a, Pow, b) *\) *)
(*   (\* let ( / ) = fun a b -> Exp (a, Mul, b) *\) *)
(*   (\* let ( & ) = fun a b -> Exp (a, UnAnd, b) *\) *)
(*   (\* let ( * ) = fun a b -> Exp (a, Xor, b) *\) *)

(* end *)

module Solution(Input : I) = struct
  open Int64 

  let pattern = Re.(compile (seq [opt(char '-'); rep1 digit]))

  let (rregA :: rregB :: rregC :: progL) = Re.matches pattern Input.input |> List.map ~f:Int64.of_string

  type 'a state = { regA : 'a; regB : 'a; regC : 'a }
  
  let state = {regA=rregA; regB=rregB; regC=rregC}
  let prog = Array.of_list progL |> Array.map ~f:to_int_exn


  let rec exec buff state ind =
    let read_combo state =
      function
      | n when Int.(n < 4) -> of_int n
      | 4 -> state.regA
      | 5 -> state.regB
      | 6 -> state.regC
    in
    (* Printf.printf "{%d %d %d}\n" state.regA state.regB state.regC; *)
    (* Printf.printf "%d %d\n" prog.(ind) prog.(ind + 1); *)
    match prog.(ind) with
    | 0 -> let den = to_int_exn (read_combo state Int.(prog.(ind + 1))) in
           exec buff {state with regA = shift_right state.regA den} Int.(ind + 2)
    | 1 -> let lit = (of_int Int.(prog.(ind + 1))) in
           exec buff {state with regB = bit_xor state.regB lit} Int.(ind + 2)
    | 2 -> let com = read_combo state Int.(prog.(ind + 1)) in
           exec buff {state with regB = bit_and com (of_int 7)} Int.((ind + 2))
    | 3 -> if equal state.regA zero then
             exec buff state Int.(ind + 2)
           else
             exec buff state Int.(prog.(ind + 1))
    | 4 -> exec buff {state with regB = bit_xor state.regB state.regC} Int.(ind + 2)
    | 5 -> let com = read_combo state Int.(prog.(ind + 1)) in
           exec ((bit_and com (of_int 7)) :: buff) state Int.(ind + 2)
    | 6 -> let den = to_int_exn (read_combo state Int.(prog.(ind + 1))) in
           exec buff {state with regB = shift_right state.regA den} Int.(ind + 2)
    | 7 -> let den = to_int_exn (read_combo state Int.(prog.(ind + 1))) in
           exec buff {state with regC = shift_right state.regA den} Int.(ind + 2)
    | exception Invalid_argument _ -> List.rev buff

  (* let rec unexec buff state ind = *)
  (*   let open Symb in *)
  (*   let read_combo state = function *)
  (*     | n when n < 4 -> lit n *)
  (*     | 4 -> state.regA *)
  (*     | 5 -> state.regB *)
  (*     | 6 -> state.regC *)
  (*   in *)
  (*   if ind < 0 then state *)
  (*   else *)
  (*     match prog.(ind) with *)
  (*     | 0 -> let den = (lit 2) ^ read_combo state prog.(ind + 1) in *)
  (*            unexec buff {state with regA=state.regA / den} (ind - 2) *)
  (*     | 1 -> let v = lit (prog.(ind + 1)) in *)
  (*            unexec buff {state with regB=state.regB * v} (ind - 2) *)
  (*     | 2 -> let v = lit (prog.(ind + 1)) in *)
  (*            unexec buff {state with regB=state. *)
  (*     | exception Invalid_argument _ -> unexec buff state (ind - 2) *)

  let part1 () =
    String.concat ~sep:"," (List.map ~f:Int64.to_string (exec [] state 0))

  let part2 () =
    let rec aux i =
      if rem i (of_int 1000000) = zero then print_endline (to_string i);
      (* if i > 2097152 then 0 else *)
      let out_buff = exec [] {state with regA = i} 0 in
      if List.equal Int64.equal out_buff progL then
        i
      else
        aux (i + one)
    in
    to_string (aux zero)
    

  let res = match Input.part with
    | `First  -> part1 ()
    | `Second -> part2 ()
  
end

let () =
  print_endline "";
  let args = Sys.get_argv () in
  let file = In_channel.read_all args.(1) in
  let module S =
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
  Printf.printf "Answer: %s\n" (S.res);
  (* Printf.printf "part2: %s\n" (Part2.res)   *)
