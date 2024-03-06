let () = 
  let grammar = Parser.parse(Utils.get_infile) in
  print_endline "done"