all: tmp tmp/all-done

check: tmp tmp/check-done

clean:
	rm -rf tmp/

.gitignore:
	printf '.env\ntmp/\n' > $@

index.html:
	touch $@

tmp:
	mkdir $@

tmp/all-done: .gitignore flake.lock flake.nix index.html
	nix develop --ignore-environment --keep DEBUG .#all
	touch $@

tmp/check-done: .gitignore flake.lock flake.nix index.html
	nix fmt
	nix flake check
	touch $@
