(* Generates a unique symbol name for each symbol - used to diffrienciate duplicates *)
(* However this will not make the state machine a tree anymore without further refactoring, it will make the machine
Look like multiple linked lists with a common - needed for homonymus rules *)
let get_symbol_id keymap trans_list =
  let symbol = fst (snd keymap) in
  let filtered = List.find_all (fun x -> 
    Utils.strncmp (snd (fst x)) symbol (String.length symbol) = 0
    ) trans_list in
  match List.length filtered with
  | 0 -> ""
  | len -> "_" ^ (string_of_int len)

(* Adds a move to an existing state; the move will be configured by user input *)
(* This function denies dupes*)
let add_move_to (base: Types.transition list) watchstate to_state keystroke = 
  List.map (fun transition -> 
    if fst transition != watchstate then 
      transition
    else
      (fst transition, (snd transition)@[(keystroke, to_state)])
    ) base

(* Cretes a new state in the transitions list with no moves *)
let add_state_to (base: Types.transition list) head_state = 
  base@[(head_state, [])]


(* Function to generate a single path given a 'watchstate' and a single movemap (a list of symbols that form a path)
This will call recursively until movemap is empty.

The watchstate is a state that represents the current state of the generation.
We wither add the moves to this state; or create a new state to add moves to. *)
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

(* Shell function to generate a populated list; the idea is to generate the transitions branch by branch
(branch meaning a path from init state to a the final symbol of that state)
Each call of this will generate the transitions for the first path in movemaps, and the path
appending the base transitions will be reflected in the return value  *)
let rec populate_transition base_transitions movemaps init_state =
  match movemaps with
  | [] -> base_transitions
  | head :: [] ->
    apply_path base_transitions head init_state
  | head :: tail -> 
    let new_base = apply_path base_transitions head init_state in
    populate_transition new_base tail init_state

(* Shell function to build the transitions part of a machine struct; will declare an initial transition list
and then populate use that to generate a fully populated list *)
let build_transitions movemaps init_state = 
  let base_transitions = [(init_state, [])] in
  populate_transition base_transitions movemaps init_state

(* Shell function to build a machine struct *)
let build_machine (grammar: Types.grammar) is_debug =
  let init_state = ("INIT", "INIT") in
  let final_states = List.map (fun movemap -> ("FINAL", fst(movemap))) grammar.movemap in
  let transitions = build_transitions grammar.movemap init_state in
  if is_debug then begin
    List.iter (fun trans -> 
      TypeUtils.print_transition trans;
      ) transitions
  end;
  Types.{
    curr_state = init_state;
    final_accept = final_states;
    transitions = transitions;
  }