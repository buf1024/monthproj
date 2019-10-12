// Code generated by protoc-gen-micro. DO NOT EDIT.
// source: proto/user/user.proto

package com_toyent_srv_user

import (
	fmt "fmt"
	proto "github.com/golang/protobuf/proto"
	math "math"
)

import (
	context "context"
	client "github.com/micro/go-micro/client"
	server "github.com/micro/go-micro/server"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion3 // please upgrade the proto package

// Reference imports to suppress errors if they are not otherwise used.
var _ context.Context
var _ client.Option
var _ server.Option

// Client API for User service

type UserService interface {
	Open(ctx context.Context, in *OpenRequest, opts ...client.CallOption) (*OpenResponse, error)
	Query(ctx context.Context, in *QueryRequest, opts ...client.CallOption) (*QueryResponse, error)
	Auth(ctx context.Context, in *AuthRequest, opts ...client.CallOption) (*AuthResponse, error)
}

type userService struct {
	c    client.Client
	name string
}

func NewUserService(name string, c client.Client) UserService {
	if c == nil {
		c = client.NewClient()
	}
	if len(name) == 0 {
		name = "com.toyent.srv.user"
	}
	return &userService{
		c:    c,
		name: name,
	}
}

func (c *userService) Open(ctx context.Context, in *OpenRequest, opts ...client.CallOption) (*OpenResponse, error) {
	req := c.c.NewRequest(c.name, "User.Open", in)
	out := new(OpenResponse)
	err := c.c.Call(ctx, req, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *userService) Query(ctx context.Context, in *QueryRequest, opts ...client.CallOption) (*QueryResponse, error) {
	req := c.c.NewRequest(c.name, "User.Query", in)
	out := new(QueryResponse)
	err := c.c.Call(ctx, req, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *userService) Auth(ctx context.Context, in *AuthRequest, opts ...client.CallOption) (*AuthResponse, error) {
	req := c.c.NewRequest(c.name, "User.Auth", in)
	out := new(AuthResponse)
	err := c.c.Call(ctx, req, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// Server API for User service

type UserHandler interface {
	Open(context.Context, *OpenRequest, *OpenResponse) error
	Query(context.Context, *QueryRequest, *QueryResponse) error
	Auth(context.Context, *AuthRequest, *AuthResponse) error
}

func RegisterUserHandler(s server.Server, hdlr UserHandler, opts ...server.HandlerOption) error {
	type user interface {
		Open(ctx context.Context, in *OpenRequest, out *OpenResponse) error
		Query(ctx context.Context, in *QueryRequest, out *QueryResponse) error
		Auth(ctx context.Context, in *AuthRequest, out *AuthResponse) error
	}
	type User struct {
		user
	}
	h := &userHandler{hdlr}
	return s.Handle(s.NewHandler(&User{h}, opts...))
}

type userHandler struct {
	UserHandler
}

func (h *userHandler) Open(ctx context.Context, in *OpenRequest, out *OpenResponse) error {
	return h.UserHandler.Open(ctx, in, out)
}

func (h *userHandler) Query(ctx context.Context, in *QueryRequest, out *QueryResponse) error {
	return h.UserHandler.Query(ctx, in, out)
}

func (h *userHandler) Auth(ctx context.Context, in *AuthRequest, out *AuthResponse) error {
	return h.UserHandler.Auth(ctx, in, out)
}