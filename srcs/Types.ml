
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

(*TODO - change this to a custom compare function that matches when one of the elems match*)
module KeymapSet = Set.Make(struct
 type t = string * (string * string)
 let compare = compare (* This uses the built-in compare function for tuples *)
end)

type grammar = {
  keymap: keymap;
  movemap: movemap;
}
