let print_debug_info is_debug move =
  if is_debug then begin
    TypeUtils.print_move move
  end

let remove_first_char str =
  if str = "" then "" else
  String.sub str 1 ((String.length str) - 1)

let cpy_machine_with_to_state machine to_state =
  Types.{
    curr_state = to_state;
    final_accept = machine.final_accept;
    transitions = machine.transitions;
  }

let extract_read_char line =
  if String.length line > 0 then
    String.make 1 (String.get line 0)
  else
    "\n"

let locate_transition curr_state transitions =
  List.find_opt (fun trans -> fst trans = curr_state) transitions

let locate_move moves read_char =
  List.find_opt (fun move -> fst move = read_char) moves

let locate_moves moves read_char =
  List.filter (fun move -> fst move = read_char) moves

let rec process_line line (machine: Types.machine) is_debug =
  let in_finals = List.find_opt (fun state -> state = machine.curr_state) (machine.final_accept) in
  match in_finals with
  | Some final_state -> 
    TypeUtils.print_state final_state
  | None ->
    let read_char = extract_read_char line in
    match locate_transition machine.curr_state machine.transitions with
    | None -> 
      print_string "No transition found for curr_state";
      print_endline (snd machine.curr_state)
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
          print_string "No move found for read_char: "
          print_endline read_char

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