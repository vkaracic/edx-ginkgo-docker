OPENEDX_RELEASE = 'open-release/ginkgo.1'
DEVSTACK_WORKSPACE ?= $(shell pwd)

OS := $(shell uname)

export OPENEDX_RELEASE
export DEVSTACK_WORKSPACE

build.base:
	docker build -t vkaracic/xenial-base:ginkgo.1 build/xenial-base

build.edxapp:
	docker build -t vkaracic/edxapp:ginkgo.1 build/edxapp

clone:
	./clone-repos.sh

provision:
	./provision.sh

up:
	docker-compose -f docker-compose.yml -f docker-compose-host.yml up
