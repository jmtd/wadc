EXAMPLES := $(wildcard ../examples/*wl)
MAPS     := $(addprefix img/map_, $(addsuffix .png, $(basename $(notdir $(EXAMPLES)))))
PWD      := $(shell pwd)
JAR      := ../target/wadc-3.0.jar

# this is 14:640ff208d353 tip https://bitbucket.org/alexmax2742/omgifol
# does not support Hexen format maps
#OMGIFOLD := $(HOME)/git/doom/omgifol
#OMGISUFX := _map
# this is 582da975f078d0a9e559cda8a35225214203104e git@github.com:devinacker/omgifol.git
OMGIFOLD := /data/git/doom/omgifol
OMGISUFX := _map

default: index.html $(MAPS)

img/map_%.png: wads/%.wad img
	$(eval LABEL:=$(shell if ! lswad $< | grep -o -m1 '^MAP..' ; then lswad $< | grep -o -m1 '^E.M.'; fi))
	cd $(OMGIFOLD)/demo && python drawmaps.py $(PWD)/$< $(LABEL) 800 png
	mv $(OMGIFOLD)/demo/$(LABEL)$(OMGISUFX).png $@

# WadCCLI limitation: writes out adjacent to .wl, not $PWD
wads/%.wl: ../examples/%.wl wads
	cp $< $@

wads/%.wad: wads/%.wl wads
	java -cp $(JAR) org.redmars.wadc.WadCCLI $<
	zdbsp $@ -o $@

index.html: examples.adoc $(MAPS)
	asciidoctor examples.adoc -o $@

examples.adoc: examples.adoc.in build-index.sh $(EXAMPLES) $(MAPS)
	./build-index.sh > examples.adoc

wads:
	mkdir -p wads

img:
	mkdir -p img

clean:
	rm -rf index.html examples.adoc wads $(MAPS)
	-rmdir img

# this should preserve wads/*.wad etc.
.SECONDARY:

.PHONY: clean default
