let () = 
  let grammar = Parser.parse(Utils.get_infile) in
  let machine = MachineBuilder.build_machine grammar in
  print_endline "done"