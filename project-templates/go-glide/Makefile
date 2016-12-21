# generate version number
version=$(shell git describe --tags --long --always|sed 's/^v//')
binfile=main

all: glide.lock vendor
	go build  -ldflags "-X main.version=$(version)" $(binfile).go
	-@go fmt ||exit

static: glide.lock vendor
	go build  -ldflags "-X main.version=$(version) -extldflags \"-static\"" -o $(binfile).static $(binfile).go

arm:
	GOARCH=arm go build  -ldflags "-X main.version=$(version) -extldflags \"-static\"" -o $(binfile).arm $(binfile).go
	GOARCH=arm64 go build  -ldflags "-X main.version=$(version) -extldflags \"-static\"" -o $(binfile).arm64 $(binfile).go
clean:
	rm -rf vendor
vendor: glide.lock
	glide install && touch vendor
glide.lock: glide.yaml
	glide update && touch glide.lock
glide.yaml:
version:
	@echo $(version)
