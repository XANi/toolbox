#!/bin/bash
# as of go version go1.4.2 linux/amd64, generating coverage is still broken, use workaround

cd `git rev-parse --show-toplevel`

go test -coverprofile cover.out
sed -i -e "s#.*/\(.*\.go\)#\./\\1#" cover.out
go tool cover -html=cover.out
