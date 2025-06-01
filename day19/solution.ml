open Core

module type I = sig
  val input : string
  val part  : [> `First | `Second]
end

module Solution(Input : I) = struct
  let repat = Re.(compile (rep1 alpha))

  let (patterns, towels) =
    let (patterns :: _ :: towels) = String.split_lines Input.input in
    (Re.matches repat patterns, towels)

  let any = List.fold ~init:false ~f:( || )
  let sum = List.sum (module Int) ~f:Fn.id
  
  let substring ?len s ~pos =
    let len = match len with
      | Some l -> l
      | None -> String.length s - pos  (* Default to the rest of the string *)
    in
    if pos < 0 || len < 0 || pos + len > String.length s then
      raise (Invalid_argument "")
    else
      (String.sub s ~pos ~len)

  module StringMap = Map.Make(String)
  let cache = ref StringMap.empty
  let rec creatable towel =
    let aux towel =
      if String.is_empty towel then 1 else
        patterns
        |> List.map ~f:(
               fun prefix -> if String.is_prefix towel ~prefix then
                               creatable (substring towel ~pos:(String.length prefix))
                             else 0)
        |> sum
    in
    match StringMap.find !cache towel with
    | Some res -> res
    | None ->
       let res = aux towel in
       cache := StringMap.add_exn !cache ~key:towel ~data:res;
       res

  let part1 () = List.(towels |> filter ~f:(fun t -> creatable t > 0) |> length |> string_of_int)

  let part2 () = List.(towels |> map ~f:creatable |> sum (module Int) ~f:Fn.id |> string_of_int)

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

