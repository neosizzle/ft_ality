

(* Print keymap for debug *)
let print_keymap (keymap: Types.keymap) = 
  Format.printf "%s maps to %s(%s)\n" (fst keymap) (fst((snd keymap))) (snd((snd keymap)))

(* Print movemap for debug *)
let print_movemap movemap = 
  List.iter (fun keymap -> Format.printf "%s -> " (fst((snd keymap))) ) (snd movemap);
  Format.printf "%s\n" (fst movemap)

(* Print state for debug *)
let print_state state =
  Format.printf "[%s] %s\n" (fst state) (snd state) 

(* Print move for debug *)
let print_move move =
  let state = snd move in
  if fst move = "\n" then begin
    Format.printf "read: (newline) -> [%s] %s\n" (fst state) (snd state) 
  end
  else
    Format.printf "read: %s -> [%s] %s\n" (fst move) (fst state) (snd state) 

(* Print transition for debug *)
let print_transition transition = 
  Format.printf "----------transition start-------\n";
  let state = fst transition in
  let movelist = snd transition in
  Format.printf "readstate: %s\n" (snd state);
  List.iter (fun move -> print_move move) movelist;
  Format.printf "----------transition end-------\n"