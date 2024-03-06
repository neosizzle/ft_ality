(* Print keymap for debug *)
let print_keymap (keymap: Types.keymap) = 
  Format.printf "%s maps to %s(%s)\n" (fst keymap) (fst((snd keymap))) (snd((snd keymap)))

(* Print movemap for debug *)
let print_movemap movemap = 
  List.iter (fun keymap -> Format.printf "%s -> " (fst((snd keymap))) ) (snd movemap);
  Format.printf "%s\n" (fst movemap)
