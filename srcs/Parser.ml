(* Parse the keys section of the grammar file into a keymap list *)
let rec parse_keymap file_channel curr_items keymapset =
  let readline_res = ParserUtils.readline_wrapper file_channel in
  match readline_res with
  | (1, _) -> Utils.print_and_exit "Failed to read seperator"
  | (0, str) ->
    if compare str "---" == 0 then begin
      curr_items
    end else begin
      let tokens = String.split_on_char ':' str in
      let keymap = ParserUtils.validate_key tokens in
      match Types.KeymapSet.find_opt keymap keymapset with
      | Some x -> Utils.print_and_exit "Duplicated keymap found"
      | None ->
        let new_keymapset = Types.KeymapSet.add keymap keymapset in
        parse_keymap file_channel (curr_items@[keymap]) new_keymapset
    end
  | (_, _) -> Utils.print_and_exit "Unexpected readline_res"

(* Parse the moves section of the grammar file into a movemap list *)
let rec parse_movemap file_channel (curr_items:Types.movemap list) keymaps movemapset =
  let readline_res = ParserUtils.readline_wrapper file_channel in
  match readline_res with
  | (1, _) -> curr_items
  | (0, str) ->
    if compare str "---" == 0 then begin
      Utils.print_and_exit "sperator read"
    end else begin
      let tokens = String.split_on_char ':' str in
      let movemap = ParserUtils.validate_move tokens keymaps in
      match Types.MovemapSet.find_opt movemap movemapset with
      | Some x -> Utils.print_and_exit "Duplicated move"
      | None -> let new_movemapset = Types.MovemapSet.add movemap movemapset in
        parse_movemap file_channel (curr_items@[movemap]) keymaps new_movemapset
    end
  | (_, _) -> Utils.print_and_exit "Unexpected readline_res"

(* Shell function for parsing the input grammar file  *)
let parse file_channel = 
  let keymapset = Types.KeymapSet.empty in
  let movemapset = Types.MovemapSet.empty in
  let keymaps = parse_keymap file_channel [] keymapset in
  let movemaps = parse_movemap file_channel [] keymaps movemapset in 
  List.iter (fun keymap -> TypeUtils.print_keymap keymap) keymaps;
  List.iter (fun movemap -> TypeUtils.print_movemap movemap) movemaps;
  Types.{
    keymap = keymaps;
    movemap = movemaps;
  }

