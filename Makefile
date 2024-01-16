HUGO_BIN=hugo

.PHONY: build
build:
	$(HUGO_BIN) --themesDir=../.. --source=exampleSite

server_build:
	cd exampleSite/public && python3 -m http.server

clean: 
	rm -rf exampleSite/public

.PHONY: demo
demo:
	$(HUGO_BIN) server -D --themesDir=../.. --source=exampleSite --bind 0.0.0.0
