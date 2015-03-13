clean:
	rm -f build/*

compile: clean
	moonc src/
	mv src/*.lua build/
	chmod 0755 build/*
