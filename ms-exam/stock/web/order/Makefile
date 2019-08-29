
GOPATH:=$(shell go env GOPATH)


.PHONY: build
build:
	go build -o order-web main.go

.PHONY: install
install: build
	cp order-web ../../bin/

.PHONY: clean
clean:
	rm order-web

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker: build
	GO_ENABLED=0 GOOS=linux go build -o order-web main.go
	docker build . -t order-web:latest
