# Go


export GODEBUG=gctrace=1

## Profiling

    go tool pprof -http=:8080 "http://localhost:6060/debug/pprof/profile?seconds=20"


## Generate coverage

    $(go list ./... |grep -v vendor)
    echo 'mode: atomic' > cover.out && go list ./... | grep -v vendor|xargs -n1 -I{} sh -c 'go test -v -covermode=atomic -coverprofile=coverage.tmp {} && tail -n +2 coverage.tmp >> cover.out' && rm coverage.tmp
