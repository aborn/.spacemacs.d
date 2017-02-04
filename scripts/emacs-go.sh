#!/usr/bin/env bash

# 将下面环境变量添加到.zshrc或者.bashrc里
# export GOPATH=$HOME/Go
# export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

# 创建目录
# mkdir -p $GOPATH

# install spacemacs go pre-requisites

go get -u -v github.com/nsf/gocode
go get -u -v github.com/rogpeppe/godef
go get -u -v golang.org/x/tools/cmd/oracle
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v golang.org/x/tools/cmd/goimports
