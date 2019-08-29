
GOPATH:=$(shell go env GOPATH)


.PHONY: proto
proto:
	protoc --proto_path=${GOPATH}/src:. --micro_out=. --go_out=. proto/stock/stock.proto

.PHONY: build
build: proto
	go build -o stock-srv main.go plugin.go

.PHONY: install
install: build
	cp stock-srv ../../bin/

.PHONY: clean
clean:
	rm stock-srv

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker: proto
	GO_ENABLED=0 GOOS=linux go build -o stock-srv main.go plugin.go
	docker build . -t stock-srv:latest
