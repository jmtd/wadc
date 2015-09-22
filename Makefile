default: wadc.jar

wadc.jar: classes
	cd src && jar cef MainFrame ../wadc.jar *.class ../include ../LICENSE.txt

v := $(shell git describe)
src/Version.java: src/Version.java.in
	sed 's/VERSION/$(v)/' $< > $@

classes: src/Version.java
	javac src/*.java

clean:
	rm -f src/*.class wadc.jar wadc.zip

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
