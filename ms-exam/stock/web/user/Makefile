
GOPATH:=$(shell go env GOPATH)

.PHONY: proto
proto:
	protoc --proto_path=${GOPATH}/src:.  --go_out=. proto/user/user.proto

.PHONY: build
build: proto
	go build -o user-web main.go

.PHONY: install
install: build
	cp user-web ../../bin/

.PHONY: clean
clean:
	rm user-web

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker:
	GO_ENABLED=0 GOOS=linux go build -o user-web main.go
	docker build . -t user-web:latest
