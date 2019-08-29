
GOPATH:=$(shell go env GOPATH)

.PHONY: build
build:
	go build -o stock-web main.go

.PHONY: install
install: build
	cp stock-web ../../bin/

.PHONY: clean
clean:
	rm stock-web

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker:
	GO_ENABLED=0 GOOS=linux go build -o stock-web main.go
	docker build . -t stock-web:latest
