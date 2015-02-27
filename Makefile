clean:
	rm build/*

compile: clean
	moonc src/
	mv src/*.lua build/
