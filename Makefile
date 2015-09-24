default: wadc.jar

wadc.jar: classes
	cd build && jar cef org.redmars.wadc.WadC ../wadc.jar \
        org/redmars/wadc/*.class ../include ../LICENSE.txt

v := $(shell git describe)
org/redmars/wadc/Version.java: Version.java.in
	sed 's/VERSION/$(v)/' $< > $@

classes: org/redmars/wadc/Version.java
	mkdir -p build
	javac org/redmars/wadc/*.java -d build

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

.PHONY: clean default version org/redmars/wadc/Version.java classes
