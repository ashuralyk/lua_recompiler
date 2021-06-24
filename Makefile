CC := gcc-10
LDFALGS := -ldl -lm

CHECK_BUILD_DIR = $(shell if [ -d build ]; then echo "exist"; else echo "noexist"; fi)
ifeq ("$(CHECK_BUILD_DIR)", "noexist")
MKDIR=mkdir build
RMDIR=
else
MKDIR=
RMDIR=rm -r build
endif

all: build/main build/test

build/main: main.c build/liblua.a
	$(CC) $^ $(LDFALGS) -o $@

build/test: test.c build/liblua.a
	$(CC) $^ $(LDFALGS) -o $@

build/liblua.a:
	make -C ./lua a
	$(MKDIR)
	cp lua/build/liblua.a build/

clean:
	$(RMDIR)