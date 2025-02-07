MAKEFILE_DIR := $(shell dirname $(realpath $(MAKEFILE_LIST)))
MAKEFILE_DIR_NAME := $(shell basename $(MAKEFILE_DIR))
REPOSITORY_DIR := $(shell git -C $(MAKEFILE_DIR) rev-parse --show-toplevel)

all: tmp tmp/all-done

check: ${REPOSITORY_DIR}/tmp ${REPOSITORY_DIR}/tmp/check-done

clean:
	rm -rf ${REPOSITORY_DIR}/tmp/
	find ${REPOSITORY_DIR} -type f -exec touch {} +

tmp:
	mkdir $@

tmp/all-done: ${REPOSITORY_DIR}/flake.lock default.nix index.html
	if [ -z "${DEBUG}" ]; then \
		nix develop ".#${MAKEFILE_DIR_NAME}" --command http-server; \
	fi
	touch $@

${REPOSITORY_DIR}/tmp:
	mkdir $@

${REPOSITORY_DIR}/tmp/check-done: ${REPOSITORY_DIR}/flake.lock default.nix index.html
	nix flake check
	nix fmt
	touch $@
