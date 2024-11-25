all: tmp tmp/all-done

check: tmp tmp/check-done

clean:
	rm -rf result tmp/

.gitignore:
	printf '.env\nresult\ntmp/\n' > $@

flake.lock:
	nix flake update

flake.nix:
	nix flake init

index.html:
	touch $@

tmp:
	mkdir $@

tmp/all-done: .gitignore flake.lock flake.nix index.html
	nix develop --ignore-environment --keep DEBUG .#all
	touch $@

tmp/check-done: .gitignore flake.lock flake.nix index.html
	nix fmt
	if ls -ap | grep -v -E -x './|../|.env|.gitignore|CNAME|Makefile|index.html|flake.lock|flake.nix|prm/|pyscript/|python/|script.js|style.css|tmp/' | grep -q .; then false; fi
	test $$(basename $$(pwd)) = "docs"
	touch $@
