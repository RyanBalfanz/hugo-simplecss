HUGO_BIN=hugo

.PHONY: all
all: build

.PHONY: clean
clean:
	rm -rf exampleSite/public

.PHONY: test
test:

.PHONY: build
build:
	$(HUGO_BIN) --themesDir=../.. --source=exampleSite

cfp_pre_build:
	# Fix theme name due to the way the Cloudflare Pages build system works
	@sed -i -e 's/hugo-simplecss/repo/g' exampleSite/hugo.toml
	@sed -i -e 's/example.org/hugo-simplecss.pages.dev/g' exampleSite/hugo.toml

cfp_build: cfp_pre_build build

server_build:
	cd exampleSite/public && python3 -m http.server

.PHONY: demo
demo:
	$(HUGO_BIN) server -D --themesDir=../.. --source=exampleSite --bind 0.0.0.0
