NAME = ft_ality

# Order matters, no way to escape the interperter :()
SRCS = srcs/Types.ml srcs/Utils.ml srcs/ParserUtils.ml srcs/Parser.ml srcs/main.ml
SRCS_OBJS_NATIVE = $(SRCS:.ml=.cmx)

INTERFACES = 
INTERFACES_OBJS = $(INTERFACES:.mli=.cmi)

# PKGFLAGS = -package yojson,spectrum,core
PKGFLAGS =
LINKFLAGS = -linkpkg

all : $(NAME)

# remove clean after name?
$(NAME): $(INTERFACES_OBJS) $(SRCS_OBJS_NATIVE) 
	@echo "..........native linking........"
	eval `opam env` && ocamlfind ocamlopt $(PKGFLAGS) $(LINKFLAGS) -o $(NAME) $(SRCS_OBJS_NATIVE) -I srcs
	$(MAKE) clean

setup_mac : # mac with brew only
	hash -r
	type ocaml || brew install ocaml

	hash -r
	type ocamlfind || brew install ocaml-findlib

	hash -r
	type opam || \
		(brew install opam &&\
		opam init -y)

	hash -r 
	eval `opam env` && opam -y install yojson spectrum core

setup_linux: #linux with apt
	hash -r
	type ocaml || sudo apt install -y ocaml-interp

	hash -r
	type ocamlfind || sudo apt install -y ocaml-findlib

	hash -r
	type opam || \
		(sudo apt install -y opam &&\
		opam init -y)

	hash -r 
	eval `opam env` && opam -y install yojson spectrum core

.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmx : 
	@echo "..........native compiling........"
	eval `opam env` && ocamlfind ocamlopt  $(PKGFLAGS) -c $< -I srcs

.mli.cmi :
	@echo "..........compiling headers........"
	ocamlc -c $< -I srcs

clean : 
	rm -f srcs/*.o srcs/*.cmx srcs/*.cmi srcs/*.cmo

fclean : clean
	rm -f $(NAME)

re : fclean all