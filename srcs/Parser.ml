let rec parse_keymap file_channel curr_items keymapset =
  let readline_res = ParserUtils.readline_wrapper file_channel in
  match readline_res with
  | (1, _) -> raise (Failure "Failed to read sperator")
  | (0, str) ->
    if compare str "---" == 0 then begin
      curr_items
    end else begin
      let tokens = String.split_on_char ':' str in
      let keymap = ParserUtils.validate_key tokens in
      match Types.KeymapSet.find_opt keymap keymapset with
      | Some x -> raise (Failure "Duplicated keymap found")
      | None ->
        let new_keymapset = Types.KeymapSet.add keymap keymapset in
        parse_keymap file_channel (curr_items@[keymap]) new_keymapset
    end
  | (_, _) -> raise (Failure "Unexpected readline_res")

let rec parse_movemap file_channel (curr_items:Types.movemap list) keymaps movemapset =
  let readline_res = ParserUtils.readline_wrapper file_channel in
  match readline_res with
  | (1, _) -> curr_items
  | (0, str) ->
    if compare str "---" == 0 then begin
      raise (Failure "sperator read")
    end else begin
      let tokens = String.split_on_char ':' str in
      let movemap = ParserUtils.validate_move tokens keymaps in
      match Types.MovemapSet.find_opt movemap movemapset with
      | Some x -> raise (Failure "Duplicated movemap found")
      | None ->
        let new_movemapset = Types.MovemapSet.add movemap movemapset in
       parse_movemap file_channel (curr_items@[movemap]) keymaps new_movemapset
    end
  | (_, _) -> raise (Failure "Unexpected readline_res")

let parse file_channel = 
  let keymapset = Types.KeymapSet.empty in
  let movemapset = Types.MovemapSet.empty in
  let keymaps = parse_keymap file_channel [] keymapset in
  let movemaps = parse_movemap file_channel [] keymaps movemapset in 
  Types.{
    keymap = keymaps;
    movemap = movemaps;
  }

