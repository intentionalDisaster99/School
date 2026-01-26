CLASS = Main

# 1. Mark 'run' as a "Phony" target.
#    This tells Make: "run is not a file, it's an action. DO IT EVERY TIME."
.PHONY: run clean

# 2. Put 'run' first so it becomes the default
run: build
	java $(CLASS)

build: $(CLASS).class

$(CLASS).class: $(CLASS).java
	javac $(CLASS).java

clean:
	rm -f *.class
