build:
	gnatmake -Pauj_tools

install: build
	cp -p $$(find . -maxdepth 1 -type f -perm -ugo=x) ${HOME}/bin/
