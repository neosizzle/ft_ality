
(* A set containing characters only, uses Stdlib compare *)
module CharSet = Set.Make (
struct
	type t = char
	let compare = Stdlib.compare
end)

(* A set containing strings only, uses String compare *)
module StringSet = Set.Make (
struct
	type t = string
	let compare = String.compare
end)

(* Grammar definition *)
type keyinfo = (string * string) (*symbol, name*)
type keymap = (string * keyinfo) (*keystroke, keyinfo*)
type movemap = (string * (keymap list)) (*movename, keymaps*)

(* Used to validate unique keysets *)
module KeymapSet = Set.Make(struct
	type t = string * (string * string)
	let compare = fun (l_s1, (l_s2, l_s3)) (r_s1, (r_s2, r_s3)) ->
		match compare l_s1 r_s1 with
		| 0 -> 0
		| _ ->
			match compare l_s2 r_s2 with 
			| 0 -> 0
			| _ -> compare l_s3 r_s3
end)

(*Used to validate unique movesets*)
module MovemapSet = Set.Make(struct
	type t = (string * (keymap list))
	let compare = fun (l_s1, l_l1) (r_s1, r_l1) ->
		match compare l_s1 r_s1 with
		| 0 -> 0
		| _ ->
			match Utils.lists_equal l_l1 r_l1 with
			| true -> 0
			| false -> 1
end)

type grammar = {
  keymap: keymap list ;
  movemap: movemap list ;
}

(* State representation *)
type state = (string * string) (*type - INIT | NORMAL | FINAL, name*)

(* Moves representation *)
type move = (string * state) (*read character, to state*)

(*Transition representation*)
type transition = (state * (move list)) (* current state, move list *) 

(* Path refrence coutner to count which states have existsed *)
type path_ref_ctr_entry = (string * int) (* symbol, count *)
type path_ref_ctr = path_ref_ctr_entry list

(* machine representation *)
(*
current state;
final accept states;
all transitions	 	 
*)
type machine = {
	curr_state: state;
	final_accept: state list;
	transitions: transition list;
}