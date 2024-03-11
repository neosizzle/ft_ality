(* Check if string s1 ends with s2 *)
let ends_with s1 s2 = 
  let n1 = String.length s1 and n2 = String.length s2 in 
  n1 >= n2 && String.sub s1 (n1 - n2) n2 = s2

(*Given a file path, get its input channel*)
let get_infile = 
  if (Array.length Sys.argv) > 3 then begin
    print_endline "Usage: ./ft_ality <.grm file> <-d [optional]>";
    exit 1;
  end;
  if (Array.length Sys.argv) = 1 then begin
    print_endline "Usage: ./ft_ality <.grm file> <debug mode [optional]>";
    exit 1;
  end;
  if ends_with Sys.argv.(1) ".grm"= false then begin
    print_endline "not a .grm file";
    exit 1;
  end;
  let in_ch = Stdlib.open_in Sys.argv.(1) in
  in_ch

(* Determines if debug mode needs to be activated*)
let is_debug = 
if (Array.length Sys.argv) != 3 then
  false
else
  if Sys.argv.(2) = "-d" then
    true
  else
    false

(*Compare 2 lists are equal*)
let rec lists_equal l1 l2 =
  match l1, l2 with
  | [], [] -> true
  | [], _ | _, [] -> false
  | h1::t1, h2::t2 -> h1 = h2 && lists_equal t1 t2

(* Checks if string is single length lowercase alphabet *)
let is_char s =
  let len = String.length s in
  len = 1 && ('a' <= s.[0] && s.[0] <= 'z')

(* Strncmp from C *)
let strncmp s1 s2 n =
  let s1_sub = String.sub s1 0 (min n (String.length s1)) in
  let s2_sub = String.sub s2 0 (min n (String.length s2)) in
  String.compare s1_sub s2_sub

(* splits a string into a list of characters *)
let ft_split s = List.init (String.length s) (String.get s);;

(* Prints a string and exists 1*)
let print_and_exit string =
  print_endline string;
  exit 1;