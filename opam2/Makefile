SOURCES=presentation.ml
TARGET=presentation-ocp-reveal

PACKAGES= \
  -package js_of_ocaml \
  -package js_of_ocaml.syntax \
  -package omd


all: $(TARGET).js

$(TARGET).byte: presentation.ml ../src/ocp-reveal.cma
	ocamlfind ocamlc $(PACKAGES) -linkpkg -I ../src ../src/ocp-reveal.cma $(SOURCES) -o $(TARGET).byte

$(TARGET).js:  $(TARGET).byte 
	js_of_ocaml $(TARGET).byte
	mkdir -p js
	cp $(TARGET).js js

clean:
	@rm -f *.o js/*.js *.byte *.cmo *.cmi *.cma *.cmt 
