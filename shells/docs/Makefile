MAKEFILE_DIR := $(shell dirname $(realpath $(MAKEFILE_LIST)))
MAKEFILE_DIR_NAME := $(shell basename $(MAKEFILE_DIR))
REPOSITORY_DIR := $(shell git -C $(MAKEFILE_DIR) rev-parse --show-toplevel)

all: tmp tmp/all-done

check: tmp tmp/check-done

clean:
	rm -rf tmp/
	find ${REPOSITORY_DIR} -type f -exec touch {} +

index.html:
	touch $@

tmp:
	mkdir $@

tmp/all-done: ${REPOSITORY_DIR}/flake.lock default.nix index.html
	nix develop ".#${MAKEFILE_DIR_NAME}" --command bash -c "[ -z "${DEBUG}" ] && http-server || true"
	touch $@

tmp/check-done: ${REPOSITORY_DIR}/flake.lock default.nix index.html
	nix flake check
	nix fmt
	nix flake lock --no-update-lock-file
	nix build github:srid/devour-flake -L --no-link --print-out-paths --override-input flake ${REPOSITORY_DIR}/flake.nix
	touch $@
