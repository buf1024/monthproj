
GOPATH:=$(shell go env GOPATH)


.PHONY: proto
proto:
	protoc --proto_path=${GOPATH}/src:. --micro_out=. --go_out=. proto/order/order.proto

.PHONY: build
build: proto
	go build -o order-srv main.go plugin.go

.PHONY: install
install: build
	cp order-srv ../../bin/

.PHONY: clean
clean:
	rm order-srv

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker:
	GO_ENABLED=0 GOOS=linux go build -o order-srv main.go plugin.go
	docker build . -t order-srv:latest
