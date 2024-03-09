let get_symbol_id keymap trans_list =
  let symbol = fst (snd keymap) in
  let filtered = List.find_all (fun x -> 
    Utils.strncmp (snd (fst x)) symbol (String.length symbol) = 0
    ) trans_list in
  match List.length filtered with
  | 0 -> ""
  | len -> "_" ^ (string_of_int len)

let add_move_to (base: Types.transition list) watchstate to_state keystroke = 
  List.map (fun transition -> 
    if fst transition != watchstate then 
      transition
    else
      (fst transition, (snd transition)@[(keystroke, to_state)])
    ) base

let add_state_to (base: Types.transition list) head_state = 
  base@[(head_state, [])]

let rec apply_path base movemap watchstate =
  let symbols = snd movemap in
  match symbols with
  | [] -> 
    let final_state = ("FINAL", fst movemap) in
    add_move_to base watchstate final_state "\n"
  | head :: tail -> 
    let head_symbol = (fst (snd head)) ^ get_symbol_id head base in (*generate ID here*)
    let head_state = ("NORMAL", head_symbol) in
    let found_trans = List.find_opt (fun transition -> fst transition = head_state) base in
    match found_trans with
    | Some trans -> 
      let new_base = add_move_to base watchstate head_state (fst head) in
      apply_path new_base (fst movemap, tail) (fst trans)
    | None -> 
      let base_added_state = add_state_to base head_state in
      let new_base = add_move_to base_added_state watchstate head_state (fst head) in
      apply_path new_base (fst movemap, tail) head_state

let rec populate_transition base_transitions movemaps init_state =
  match movemaps with
  (*Change here to map empty list??*)
  | head :: [] ->
    apply_path base_transitions head init_state
  | head :: tail -> 
    let new_base = apply_path base_transitions head init_state in
    populate_transition new_base tail init_state

let build_transitions movemaps init_state = 
  let base_transitions = [(init_state, [])] in
  let res = populate_transition base_transitions movemaps init_state in
  List.iter (fun trans -> 
    TypeUtils.print_transition trans;
    ) res;
  res

let build_machine (grammar: Types.grammar) =
  let init_state = ("INIT", "INIT") in
  let final_states = List.map (fun movemap -> ("FINAL", fst(movemap))) grammar.movemap in
  let transitions = build_transitions grammar.movemap init_state in
  Types.{
    curr_state = init_state;
    final_accept = final_states;
    transitions = [];
  }