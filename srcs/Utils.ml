(*Given a file path, get its input channel*)
let get_infile = 
  if (Array.length Sys.argv) != 2 then begin
    print_endline "Usage: ./ft_ality <.grm file>";
    exit 1;
  end;
  let in_ch = Stdlib.open_in Sys.argv.(1) in
  in_ch

(* Print keymap for debug *)
let print_keymap (keymap: Types.keymap) = 
  Format.printf "%s maps to %s(%s)\n" (fst keymap) (fst((snd keymap))) (snd((snd keymap)))

(* Print movemap for debug *)
let print_movemap movemap = 
  List.iter (fun keymap -> Format.printf "%s -> " (fst((snd keymap))) ) (snd movemap);
  Format.printf "%s\n" (fst movemap)
