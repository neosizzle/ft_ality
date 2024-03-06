(* Reads a line, returns (0, <line>) on success and (1, "") on error*)
let readline_wrapper file_channel = 
  try
    let line_str = Stdlib.input_line file_channel in
    (0, line_str)
  with
  | _ -> (1, "")

(* Validates keymap tokens, and returns a keymap type once validated *)
let validate_key tokens =
  match tokens with
  | [keystroke; symbol; name] ->
    if Utils.is_char keystroke = false then begin
      print_endline "keystroke must be alphabet";
      exit 1
    end;
    (keystroke, (symbol, name))
  | _ -> 
    print_endline "keymap must be in format <keystroke>:<symbol>:<name>";
    exit 1

(* Validates movemap tokens, and returns a movemap type once validated *)
let validate_move tokens keymaps =
  match tokens with
  | movename:: symbols ->
    if List.length symbols = 0 then begin
      print_endline "must have at least 1 symbol in movemap";
      exit 1
    end;
    let keymap = List.map (fun symbol -> 
      match List.find_opt (fun keymap -> fst(snd keymap) = symbol) keymaps with
      | Some res -> res 
      | None -> 
        Format.printf "Symbol %s not found in keymap" symbol;
        exit 1
    ) symbols in
    (movename, keymap)
  | _ -> 
    print_endline "movemap must be in format <name>:<symbol>:...";
    exit 1