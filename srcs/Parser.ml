let rec parse_keymap file_channel curr_items =
  let readline_res = ParserUtils.readline_wrapper file_channel in
  match readline_res with
  | (1, _) -> raise (Failure "Failed to read sperator")
  | (0, str) ->
    if compare str "---" == 0 then begin
      curr_items
    end else begin
      let tokens = String.split_on_char ':' str in
      let keymap = ParserUtils.validate_key tokens in
      parse_keymap file_channel curr_items@[keymap]
    end
  | (_, _) -> raise (Failure "Unexpected readline_res")

let rec parse_movemap file_channel (curr_items:Types.movemap list) keymaps =
  let readline_res = ParserUtils.readline_wrapper file_channel in
  match readline_res with
  | (1, _) -> curr_items
  | (0, str) ->
    if compare str "---" == 0 then begin
      raise (Failure "sperator read")
    end else begin
      let tokens = String.split_on_char ':' str in
      let movemap = ParserUtils.validate_move tokens keymaps in
      (*infix @ operator does not work here hmm?*)
      parse_movemap file_channel (List.append curr_items [movemap]) keymaps
    end
  | (_, _) -> raise (Failure "Unexpected readline_res")

let parse file_channel = 
  let keymaps = parse_keymap file_channel [] in
  let movemaps = parse_movemap file_channel [] keymaps in 
  List.iter (fun x ->   Utils.print_movemap x) movemaps;

  print_endline "lala"

