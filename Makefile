all:
	cd chez_scheme_9.5.1/c; make

clean:
	cd chez_scheme_9.5.1/c; make clean
	cd chez_scheme_9.5.1/zlib; make clean
	find . -name '*.o' | xargs rm

