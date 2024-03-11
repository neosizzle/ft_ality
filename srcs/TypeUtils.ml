

(* Print keymap for debug *)
let print_keymap (keymap: Types.keymap) = 
  print_endline ((fst keymap) ^ " maps to " ^ (fst((snd keymap))) ^ "(" ^ (snd((snd keymap))) ^ ")")

(* Print movemap for debug *)
let print_movemap movemap = 
  List.iter (fun keymap -> print_string ((fst keymap) ^ " -> ") ) (snd movemap);
  print_endline (fst movemap)

(* Print state for debug *)
let print_state state =
  print_endline ("[" ^ (fst state) ^ "] " ^ (snd state)) 

(* Print move for debug *)
let print_move move =
  let state = snd move in
  if fst move = "\n" then begin
    print_endline ("read: (newline) -> [" ^ (fst state) ^ "] " ^ (snd state))
  end
  else
    print_endline ("read: " ^ (fst move) ^ " -> [" ^ (fst state) ^ "] " ^ (snd state)) 

(* Print transition for debug *)
let print_transition transition = 
  print_endline "----------transition start-------";
  let state = fst transition in
  let movelist = snd transition in
  print_endline ("readstate: " ^ (snd state));
  List.iter (fun move -> print_move move) movelist;
  print_endline "----------transition end-------"