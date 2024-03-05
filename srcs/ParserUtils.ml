(* Reads a line, returns (0, <line>) on success and (1, "") on error*)
let readline_wrapper file_channel = 
  try
    let line_str = Stdlib.input_line file_channel in
    (0, line_str)
  with
  | _ -> (1, "")


(*TODO validate this*)
let validate_key tokens =
  match tokens with
  | [keystroke; symbol; name] -> (keystroke, (symbol, name))
  | _ -> 
    print_endline "validate_key unimplemented";
    exit 1
  
(*TODO validate this*)
let validate_move tokens keymaps =
  match tokens with
  | movename:: symbols ->
    let keymap = List.map (fun symbol -> 
      match List.find_opt (fun keymap -> fst(snd keymap) = symbol) keymaps with
      | Some res -> res 
      | None -> 
        Format.printf "Symbol %s not found in keymap" symbol;
        exit 1
    ) symbols in
    (movename, keymap)
  | _ -> 
    print_endline "validate_move unimplemented";
    exit 1