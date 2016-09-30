#!/bin/sh
set -e
set -u

findjar() {
	for jar in target/*jar; do
		if [ -f "$jar" ]; then
			echo "$jar"
			return
		fi
	done
	echo /usr/share/wadc/wadc.jar
}
JAR=${JAR:-$(findjar)}

# example of how to launch the (alpha) cli
java -cp "$JAR" org.redmars.wadc.WadCCLI "$@"
