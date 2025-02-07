MAKEFILE_DIR := $(shell dirname $(realpath $(MAKEFILE_LIST)))
MAKEFILE_DIR_NAME := $(shell basename $(MAKEFILE_DIR))
REPOSITORY_DIR := $(shell git -C $(MAKEFILE_DIR) rev-parse --show-toplevel)

all: tmp tmp/all-done

check: tmp tmp/check-done

clean:
	rm -rf tmp/
	find ${REPOSITORY_DIR} -type f -exec touch {} +

tmp:
	mkdir $@

tmp/all-done: ${REPOSITORY_DIR}/flake.lock default.nix index.html
	if [ -z "${DEBUG}" ]; then \
		nix develop ".#${MAKEFILE_DIR_NAME}" --command http-server; \
	fi
	touch $@

tmp/check-done: ${REPOSITORY_DIR}/flake.lock default.nix index.html
	nix flake check
	nix fmt
	touch $@
