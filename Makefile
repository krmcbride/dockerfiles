SHELL = bash

DEV_MIXIN_DOCKER_VERSION=$$(version=$$(cat src/main/mixin/Dockerfile.dev | grep 'DEV_MIXIN_DOCKER_VERSION='); version=$${version//DEV_MIXIN_DOCKER_VERSION=/}; echo $${version//[\" \\]/})
DEV_MIXIN_DOCKER_COMPOSE_VERSION=$$(version=$$(cat src/main/mixin/Dockerfile.dev | grep 'DOCKER_COMPOSE_VERSION='); version=$${version//DOCKER_COMPOSE_VERSION=/}; echo $${version//[\" \\]/})
NODE_16_BULLSEYE_VERSION=$$(version=$$(cat src/main/node/16-bullseye/Dockerfile.base | grep 'FROM node:'); version=$${version//FROM node:/}; echo $${version//-bullseye/})
NODE_18_BULLSEYE_VERSION=$$(version=$$(cat src/main/node/18-bullseye/Dockerfile.base | grep 'FROM node:'); version=$${version//FROM node:/}; echo $${version//-bullseye/})
CORRETTO_8_VERSION=$$(version=$$(cat src/main/corretto/8-amazonlinux2/Dockerfile.base | grep 'FROM amazoncorretto:'); version=$${version//FROM amazoncorretto:/}; echo $${version})

.PHONY: all
all: \
	clean \
	base \
	java \
	node

.PHONY: base
base: debian


##
## debian
##
.PHONY: debian
debian: debian_base debian_dev

.PHONY: debian_base
debian_base: \
	build/debian/bullseye-base/Dockerfile

.PHONY: debian_dev
debian_dev: \
	build/debian/bullseye-dev/Dockerfile

build/debian/bullseye-base/Dockerfile: src/main/debian/bullseye/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_bullseye_base=$$(cat src/main/mixin/bullseye/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/debian/bullseye-dev/Dockerfile: src/main/debian/bullseye/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_bullseye_dev=$$(cat src/main/mixin/bullseye/Dockerfile.dev); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

##
## java
##
.PHONY: java
java: \
	build/corretto/8-amazonlinux2-base/Dockerfile

build/corretto/8-amazonlinux2-base/Dockerfile: src/main/corretto/8-amazonlinux2/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_amazonlinux2_base=$$(cat src/main/mixin/amazonlinux2/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)


##
## node
##
.PHONY: node
node: \
	build/node/16-bullseye-base/Dockerfile \
	build/node/16-bullseye-dev/Dockerfile \
	build/node/18-bullseye-base/Dockerfile \
	build/node/18-bullseye-dev/Dockerfile

build/node/16-bullseye-base/Dockerfile: src/main/node/16-bullseye/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_bullseye_base=$$(cat src/main/mixin/bullseye/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/node/16-bullseye-dev/Dockerfile: src/main/node/16-bullseye/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_bullseye_dev=$$(cat src/main/mixin/bullseye/Dockerfile.dev); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/node/18-bullseye-base/Dockerfile: src/main/node/18-bullseye/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_bullseye_base=$$(cat src/main/mixin/bullseye/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/node/18-bullseye-dev/Dockerfile: src/main/node/18-bullseye/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_bullseye_dev=$$(cat src/main/mixin/bullseye/Dockerfile.dev); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)


##
## CI image
##
.PHONY: build_ci_18.09_image
build_ci_18.09_image: build/docker/18.09-ci/Dockerfile
	docker pull krmcbride/docker:18.09-ci || true
	docker build --pull --cache-from krmcbride/docker:18.09-ci -t krmcbride/docker:18.09-ci $(<D)

build/docker/18.09-ci/Dockerfile: src/main/docker/18.09-ci/Dockerfile
	@[ -d $(@D) ] || mkdir -p $(@D)
	@cp $< $@


##
## Testing
##
.PHONY: test
test: \
	test_debian \
	test_node \
	test_java

.PHONY: test_debian
test_debian: \
	test_debian_bullseye-base \
	test_debian_bullseye-dev

.PHONY: test_debian_bullseye-base
test_debian_bullseye-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:bullseye-base cat /etc/issue | grep 'Debian GNU/Linux 11'

.PHONY: test_debian_bullseye-dev
test_debian_bullseye-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:bullseye-dev cat /etc/issue | grep 'Debian GNU/Linux 11'
	@docker run -it --rm krmcbride/debian:bullseye-dev ls /usr/local/oh-my-zsh


.PHONY: test_node
test_node: \
	test_node_16-bullseye-base \
	test_node_16-bullseye-dev \
	test_node_18-bullseye-base \
	test_node_18-bullseye-dev

.PHONY: test_node_16-bullseye-base
test_node_16-bullseye-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:16-bullseye-base cat /etc/issue | grep 'Debian GNU/Linux 11'
	@version=$$(docker run -it --rm krmcbride/node:16-bullseye-base node --version); \
	echo expecting $(NODE_16_BULLSEYE_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_16_BULLSEYE_VERSION)

.PHONY: test_node_16-bullseye-dev
test_node_16-bullseye-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:16-bullseye-dev cat /etc/issue | grep 'Debian GNU/Linux 11'
	@docker run -it --rm krmcbride/node:16-bullseye-dev ls /usr/local/oh-my-zsh
	@version=$$(docker run -it --rm krmcbride/node:16-bullseye-dev node --version); \
	echo expecting $(NODE_16_BULLSEYE_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_16_BULLSEYE_VERSION)

.PHONY: test_node_18-bullseye-base
test_node_18-bullseye-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:18-bullseye-base cat /etc/issue | grep 'Debian GNU/Linux 11'
	@version=$$(docker run -it --rm krmcbride/node:18-bullseye-base node --version); \
	echo expecting $(NODE_18_BULLSEYE_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_18_BULLSEYE_VERSION)

.PHONY: test_node_18-bullseye-dev
test_node_18-bullseye-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:18-bullseye-dev cat /etc/issue | grep 'Debian GNU/Linux 11'
	@docker run -it --rm krmcbride/node:18-bullseye-dev ls /usr/local/oh-my-zsh
	@version=$$(docker run -it --rm krmcbride/node:18-bullseye-dev node --version); \
	echo expecting $(NODE_18_BULLSEYE_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_18_BULLSEYE_VERSION)


.PHONY: test_java
test_java: \
	test_corretto_8-amazonlinux2-base

.PHONY: test_corretto_8-amazonlinux2-base
test_corretto_8-amazonlinux2-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/corretto:8-amazonlinux2-base cat /etc/system-release | grep 'Amazon Linux release 2 (Karoo)'
	@version=$$(docker run -it --rm \
		krmcbride/corretto:8-amazonlinux2-base \
		bash -c 'java -version 2>&1 | grep Environment | grep Corretto | sed '\''s/1\.8\.0_/8u/'\'''); \
	echo expecting $(CORRETTO_8_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(CORRETTO_8_VERSION)


##
## Build (just for local testing, CI does not use these)
##
.PHONY: build_debian_bullseye-base
build_debian_bullseye-base:
	docker build -t krmcbride/debian:bullseye-base build/debian/bullseye-base/

.PHONY: build_debian_bullseye-dev
build_debian_bullseye-dev: build_debian_bullseye-base
	docker build -t krmcbride/debian:bullseye-dev build/debian/bullseye-dev/


##
## Plumbing
##
.PHONY: get_upstreams
get_upstreams: \
	get_docker_upstream

get_docker_upstream:
	set -e; \
	echo "Docker version is $(DEV_MIXIN_DOCKER_VERSION)"; \
	curl -sSLo src/resources/omz-custom/plugins/docker/_docker \
	    https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker; \
	echo "Docker Compose version is $(DEV_MIXIN_DOCKER_COMPOSE_VERSION)"; \
	curl -sSLo src/resources/omz-custom/plugins/docker-compose/_docker_compose \
	    https://raw.githubusercontent.com/docker/compose/$(DEV_MIXIN_DOCKER_COMPOSE_VERSION)/contrib/completion/zsh/_docker-compose

.PHONY: push_ci_18.09_image
push_ci_18.09_image: build_ci_18.09_image
	docker push krmcbride/docker:18.09-ci

.PHONY: clean
clean:
	rm -rf build

