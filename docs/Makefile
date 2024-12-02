all: tmp tmp/all-done

check: tmp tmp/check-done

clean:
	rm -rf tmp/

.gitignore:
	printf '.env\ntmp/\n' > $@

flake.lock:
	nix flake lock

index.html:
	touch $@

tmp:
	mkdir $@

tmp/all-done: .gitignore flake.lock flake.nix index.html
	if [ "$(DEBUG)" = "1" ]; then \
		exit 0; \
	else \
		nix develop --command http-server --ignore-environment --keep DEBUG; \
	fi
	touch $@

tmp/check-done: .gitignore flake.lock flake.nix index.html
	nix fmt
	nix flake check
	touch $@
