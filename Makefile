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
		*.cmd \
		*.sh \
		readme.txt \
		tutorial.md \
		LICENSE.txt \
		examples/*.wl \
		examples/old/*.wl \
		include/*.h

.PHONY: clean default
