# generate version number
version=$(shell git describe --tags --long --always --dirty|sed 's/^v//')
binfile=main

all:
	go build -ldflags "-X main.version=$(version)" $(binfile).go
	-@go fmt

static:
	go build -ldflags "-X main.version=$(version) -extldflags \"-static\"" -o $(binfile).static $(binfile).go

arm:
	GOARCH=arm go build  -ldflags "-X main.version=$(version) -extldflags \"-static\"" -o $(binfile).arm $(binfile).go
	GOARCH=arm64 go build  -ldflags "-X main.version=$(version) -extldflags \"-static\"" -o $(binfile).arm64 $(binfile).go
version:
	@echo $(version)
