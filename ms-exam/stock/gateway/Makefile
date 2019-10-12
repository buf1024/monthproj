
GOPATH:=$(shell go env GOPATH)


.PHONY: build
build:
	go build -o stock-gate main.go

.PHONY: install
install: build
	cp stock-gate ../bin/

.PHONY: clean
clean:
	rm stock-gate

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker:
	GO_ENABLED=0 GOOS=linux go build -o stock-gate main.go
	docker build . -t stock-gate:latest
