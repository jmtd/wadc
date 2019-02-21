EXAMPLES := $(filter-out %lisp.wl,$(filter-out %choz.wl,$(wildcard ../examples/*wl)))
MAPS     := $(addprefix img/map_, $(addsuffix .png, $(basename $(notdir $(EXAMPLES)))))
PWD      := $(shell pwd)
JAR      := ../target/wadc-3.0.jar
OMGIFOLD := $(HOME)/git/doom/omgifol

default: index.html $(MAPS)

img/map_%.png: wads/%.wad img
	$(eval LABEL:=$(shell if ! lswad $< | grep -o -m1 '^   MAP..' ; then lswad $< | grep -o -m1 '^    E.M.'; fi))
	cd $(OMGIFOLD)/demo && python drawmaps.py $(PWD)/$< $(LABEL) 800 png
	mv $(OMGIFOLD)/demo/$(LABEL)_map.png $@

# WadCCLI limitation: writes out adjacent to .wl, not $PWD
wads/%.wl: ../examples/%.wl wads
	cp $< $@

wads/%.wad: wads/%.wl wads
	java -cp $(JAR) org.redmars.wadc.WadCCLI $<
	glbsp $@ -o $@

index.html: examples.adoc $(MAPS)
	asciidoctor examples.adoc -o $@

examples.adoc: examples.adoc.in build-index.sh $(EXAMPLES) $(MAPS)
	./build-index.sh > examples.adoc

wads:
	mkdir -p wads

img:
	mkdir -p img

clean:
	rm -rf index.html examples.adoc wads
	-rmdir img

# this should preserve wads/*.wad etc.
.SECONDARY:

.PHONY: clean default
