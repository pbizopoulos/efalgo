all:

check: tmp/check-done

clean:
	rm -rf tmp/

.gitignore:
	printf 'tmp/\n' > $@

README:
	printf "# $$(basename $$(pwd))\n\n" > $@

tmp:
	mkdir $@

tmp/check-done: .gitignore README flake.nix tmp
	nix fmt
	if ls -ap | grep -v -E -x './|../|.env|.git/|.github/|.gitignore|CITATION.bib|LICENSE|Makefile|README|deploy.sh|deploy-requirements.sh|docs/|flake.lock|flake.nix|latex/|nix/|python/|tmp/' | grep -q .; then false; fi
	if printf "$$(basename $$(pwd))" | grep -v -E -x '^[a-z0-9]+([-.][a-z0-9]+)*$$'; then false; fi
	touch $@
