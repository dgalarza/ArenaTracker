clean:
	rm -f build/*

compile: clean
	moonc src/
	mv src/*.lua build/
