CLASSES := $(patsubst %.java,%.class,$(wildcard src/*.java))

default: wadc.jar

wadc.jar: $(CLASSES)
	cd src && jar cef MainFrame ../wadc.jar *.class ../include ../LICENSE.txt

$(CLASSES):
	javac src/*.java

clean:
	rm -f src/*.class wadc.jar wadc.zip

wadc.zip: wadc.jar
	zip wadc.zip \
		wadc.jar \
		LICENSE.txt \
		examples/*.wl \
		examples/*.h \
		examples/old/*.wl \
		examples/beta/*.wl \
		examples/beta/*.h \
		examples/beta/old/*.wl \
        doc/* \
        README.adoc \
		include/*.h

.PHONY: clean default
