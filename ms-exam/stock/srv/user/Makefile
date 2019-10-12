
GOPATH:=$(shell go env GOPATH)


.PHONY: proto
proto:
	protoc --proto_path=${GOPATH}/src:. --micro_out=. --go_out=. proto/user/user.proto

.PHONY: build
build: proto
	go build -o user-srv main.go plugin.go

.PHONY: install
install: build
	cp user-srv ../../bin/

.PHONY: clean
clean:
	rm user-srv

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker: proto
	GO_ENABLED=0 GOOS=linux go build -o user-srv main.go plugin.go
	docker build . -t user-srv:latest
