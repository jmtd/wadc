default:
	javac src/*.java
	cd src && jar cef MainFrame ../wadc.jar *.class ../include

clean:
	rm src/*.class wadc.jar

.PHONY: clean
