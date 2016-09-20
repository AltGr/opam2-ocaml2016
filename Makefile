OCPBUILD=ocp-build
JSFILE=ocp-reveal.js

all: build

build:
	$(MAKE) -C src
	$(MAKE) -C opam2 all

clean:
	$(MAKE) -C src clean
	$(MAKE) -C opam2 clean
