(* Check if string s1 ends with s2 *)
let ends_with s1 s2 = 
  let n1 = String.length s1 and n2 = String.length s2 in 
  n1 >= n2 && String.sub s1 (n1 - n2) n2 = s2

(*Given a file path, get its input channel*)
let get_infile = 
  if (Array.length Sys.argv) != 2 then begin
    print_endline "Usage: ./ft_ality <.grm file>";
    exit 1;
  end;
  if ends_with Sys.argv.(1) ".grm"= false then begin
    print_endline "not a .grm file";
    exit 1;
  end;
  let in_ch = Stdlib.open_in Sys.argv.(1) in
  in_ch

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