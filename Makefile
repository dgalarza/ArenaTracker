clean:
	rm build/*

compile:
	moonc src/
	mv src/*.lua build/
