let () = 
  let grammar = Parser.parse(Utils.get_infile) in
  let is_debug = Utils.is_debug in
  let machine = MachineBuilder.build_machine grammar is_debug in
  MachineExecutor.execute machine is_debug in
  print_endline "done"