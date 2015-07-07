# generate version number
version=$(shell git describe --tags --long --always|sed 's/^v//')

all: dep
	gom exec go build  -ldflags "-X main.version $(version)" [a-z]*go
	go fmt


dep:
	gom install
