
GOPATH:=$(shell go env GOPATH)


.PHONY: proto
proto:
	protoc --proto_path=${GOPATH}/src:. --micro_out=. --go_out=. proto/order-deal/order-deal.proto

.PHONY: build
build: proto
	go build -o order-deal-srv main.go plugin.go

.PHONY: install
install: build
	cp order-deal-srv ../../bin/

.PHONY: clean
clean:
	rm order-deal-srv

.PHONY: test
test:
	go test -v ./... -cover

.PHONY: docker
docker: proto
	GO_ENABLED=0 GOOS=linux go build -o order-deal-srv main.go plugin.go
	docker build . -t order-deal-srv:latest
