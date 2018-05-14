OPENEDX_RELEASE = 'open-release/ginkgo.master'
DEVSTACK_WORKSPACE ?= $(shell pwd)/..

OS := $(shell uname)

export OPENEDX_RELEASE
export DEVSTACK_WORKSPACE

build.base:
	docker build -t karacic/xenial-base:ginkgo.master build/xenial-base

build.edxapp:
	docker build --build-arg container_prefix=${CONTAINER_PREFIX} -t karacic/edxapp:${CONTAINER_PREFIX}-ginkgo.master build/edxapp

clone:
	./clone-repos.sh

provision:
	./provision.sh

up:
	docker-compose -f docker-compose.yml -f docker-compose-host.yml up -d

static:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_assets --settings devstack_docker'
	docker-compose exec studio bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_assets --settings devstack_docker'

watch:
	docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver watch_assets --td=/edx-themes --t=ed2go-edx-theme --system=lms'
