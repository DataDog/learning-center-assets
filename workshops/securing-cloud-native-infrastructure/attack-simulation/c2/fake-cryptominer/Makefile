.PHONY: build

build:
	GOOS=darwin GOARCH=amd64 go build -o bin/miner_darwin_amd64 ./fake-cryptominer.go
	GOOS=linux GOARCH=amd64 go build -o bin/miner_linux_amd64 ./fake-cryptominer.go

all: build
