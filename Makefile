default: wadc.jar

wadc.jar: classes
	cd build && jar cef MainFrame ../wadc.jar *.class ../include ../LICENSE.txt

v := $(shell git describe)
src/Version.java: src/Version.java.in
	sed 's/VERSION/$(v)/' $< > $@

classes: src/Version.java
	mkdir -p build
	javac src/*.java -d build

clean:
	rm -f build/*.class wadc.jar wadc.zip

version:
	git describe > VERSION

wadc.zip: wadc.jar
	zip wadc.zip \
		wadc.jar \
		LICENSE.txt \
		extra/* \
		examples/*.wl \
		examples/*.h \
		examples/old/*.wl \
		examples/beta/*.wl \
		examples/beta/*.h \
		examples/beta/old/*.wl \
        doc/* \
        README.adoc \
		include/*.h

.PHONY: clean default version src/Version.java classes
