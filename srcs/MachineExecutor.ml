(* Prints debug information on machine state *)
let print_debug_info is_debug move =
  if is_debug then begin
    TypeUtils.print_move move
  end

(* Printd debug info when a move is not found *)
let print_debug_not_found is_debug read_char =
  if is_debug then begin
    print_string "No move found for read_char: ";
    print_endline read_char
  end

(* Removes first character of string *)
let remove_first_char str =
  if str = "" then "" else
  String.sub str 1 ((String.length str) - 1)

(* Duplicate a machine without to_state *)
let cpy_machine_with_to_state machine to_state =
  Types.{
    curr_state = to_state;
    final_accept = machine.final_accept;
    transitions = machine.transitions;
  }

(* Extract the first character of a line  *)
let extract_read_char line =
  if String.length line > 0 then
    String.make 1 (String.get line 0)
  else
    "\n"

(* Find the transition in a list of machine transtions *)
let locate_transition curr_state transitions =
  List.find_opt (fun trans -> fst trans = curr_state) transitions

(* Filter out a list of moves that match the read_char in a transition *)
let locate_moves moves read_char =
  List.filter (fun move -> fst move = read_char) moves
(* 
Process the current line

This will check if the curr state is final; if yes, print state and return
If its not, read the character and see if a transition is found; if not, print err and exit
if yes, filter out the moves and recurse on all of them. *)
let rec process_line line (machine: Types.machine) is_debug =
  let in_finals = List.find_opt (fun state -> state = machine.curr_state) (machine.final_accept) in
  match in_finals with
  | Some final_state -> TypeUtils.print_state final_state
  | None ->
    let read_char = extract_read_char line in
    match locate_transition machine.curr_state machine.transitions with
    | None -> print_endline ("No transition found for curr_state" ^ (snd machine.curr_state));
    | Some transition ->
        let possible_moves = locate_moves (snd transition) read_char in
        if List.length possible_moves != 0 then begin
          List.iter (fun move ->
            print_debug_info is_debug move;
            let amended_line = remove_first_char line in
            let amended_machine = cpy_machine_with_to_state machine (snd move) in
            process_line amended_line amended_machine is_debug
            ) possible_moves
        end else 
          print_debug_not_found is_debug read_char

(* Shell function to execute a defined machine *)
let rec execute machine is_debug = 
  try
    let line = input_line stdin in
    if is_debug then begin
      print_endline "~~~~~~~~ Machine execution begin ~~~~~~~~~"
    end;
    process_line line machine is_debug;
    if is_debug then begin
      print_endline "~~~~~~~~ Machine execution end ~~~~~~~~~\n"
    end;
    execute machine is_debug ;
  with End_of_file ->
    print_endline "End of input."