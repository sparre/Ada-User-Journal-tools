GENERATED_EXECUTABLES=count_lines remove_unwanted_headers reorder_headers

EXECUTABLES=$(GENERATED_EXECUTABLES)

build:
	gnatmake -P auj_tools

test: build
	@echo No testing implemented yet.

install: build
	install -t ${HOME}/bin/ $(EXECUTABLES)

clean:
	gnatclean -P auj_tools
	rm -f *.o *.ali

distclean: clean
	rm -f $(GENERATED_EXECUTABLES)

