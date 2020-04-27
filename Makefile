SHELL = bash

DEV_MIXIN_DOCKER_VERSION=$$(version=$$(cat src/main/mixin/Dockerfile.dev | grep 'DEV_MIXIN_DOCKER_VERSION='); version=$${version//DEV_MIXIN_DOCKER_VERSION=/}; echo $${version//[\" \\]/})
DEV_MIXIN_DOCKER_COMPOSE_VERSION=$$(version=$$(cat src/main/mixin/Dockerfile.dev | grep 'DOCKER_COMPOSE_VERSION='); version=$${version//DOCKER_COMPOSE_VERSION=/}; echo $${version//[\" \\]/})
NODE_10_STRETCH_VERSION=$$(version=$$(cat src/main/node/10-stretch/Dockerfile.base | grep 'FROM node:'); version=$${version//FROM node:/}; echo $${version//-stretch/})
NODE_12_BUSTER_VERSION=$$(version=$$(cat src/main/node/12-buster/Dockerfile.base | grep 'FROM node:'); version=$${version//FROM node:/}; echo $${version//-buster/})
JAVA_8_STRETCH_VERSION=$$(version=$$(cat src/main/java/8-stretch/Dockerfile.base | grep 'FROM openjdk:'); version=$${version//FROM openjdk:/}; echo $${version//-stretch/})
CORRETTO_8_VERSION=$$(version=$$(cat src/main/corretto/8-amazonlinux2/Dockerfile.base | grep 'FROM corretto:'); version=$${version//FROM corretto:/}; echo $${version})

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
	build/debian/stretch-base/Dockerfile \
	build/debian/buster-base/Dockerfile

.PHONY: debian_dev
debian_dev: \
	build/debian/stretch-dev/Dockerfile \
	build/debian/buster-dev/Dockerfile

build/debian/stretch-base/Dockerfile: src/main/debian/stretch/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_stretch_base=$$(cat src/main/mixin/stretch/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/debian/stretch-dev/Dockerfile: src/main/debian/stretch/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_stretch_dev=$$(cat src/main/mixin/stretch/Dockerfile.dev); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/debian/buster-base/Dockerfile: src/main/debian/buster/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_buster_base=$$(cat src/main/mixin/buster/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/debian/buster-dev/Dockerfile: src/main/debian/buster/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_buster_dev=$$(cat src/main/mixin/buster/Dockerfile.dev); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

##
## java
##
.PHONY: java
java: \
	build/java/8-stretch-base/Dockerfile \
	build/java/8-stretch-dev/Dockerfile \
	build/corretto/8-amazonlinux2-base/Dockerfile

build/java/8-stretch-base/Dockerfile: src/main/java/8-stretch/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_stretch_base=$$(cat src/main/mixin/stretch/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/java/8-stretch-dev/Dockerfile: src/main/java/8-stretch/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_stretch_dev=$$(cat src/main/mixin/stretch/Dockerfile.dev); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

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
	build/node/10-stretch-base/Dockerfile \
	build/node/10-stretch-dev/Dockerfile \
	build/node/12-buster-base/Dockerfile \
	build/node/12-buster-dev/Dockerfile

build/node/10-stretch-base/Dockerfile: src/main/node/10-stretch/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_stretch_base=$$(cat src/main/mixin/stretch/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/node/10-stretch-dev/Dockerfile: src/main/node/10-stretch/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_stretch_dev=$$(cat src/main/mixin/stretch/Dockerfile.dev); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/node/12-buster-base/Dockerfile: src/main/node/12-buster/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_buster_base=$$(cat src/main/mixin/buster/Dockerfile.base); \
	    dockerize -template $<:$@; \
	    cp -R src/resources/mixin/* $(@D)

build/node/12-buster-dev/Dockerfile: src/main/node/12-buster/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    export mixin_buster_dev=$$(cat src/main/mixin/buster/Dockerfile.dev); \
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
	test_debian_stretch-base \
	test_debian_stretch-dev \
	test_debian_buster-base \
	test_debian_buster-dev

.PHONY: test_debian_stretch-base
test_debian_stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'

.PHONY: test_debian_stretch-dev
test_debian_stretch-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:stretch-dev cat /etc/issue | grep 'Debian GNU/Linux 9'
	@docker run -it --rm krmcbride/debian:stretch-dev ls /usr/local/oh-my-zsh > /dev/null

.PHONY: test_debian_buster-base
test_debian_buster-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:buster-base cat /etc/issue | grep 'Debian GNU/Linux 10'

.PHONY: test_debian_buster-dev
test_debian_buster-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:buster-dev cat /etc/issue | grep 'Debian GNU/Linux 10'
	@docker run -it --rm krmcbride/debian:buster-dev ls /usr/local/oh-my-zsh > /dev/null


.PHONY: test_node
test_node: \
	test_node_10-stretch-base \
	test_node_10-stretch-dev \
	test_node_12-buster-base \
	test_node_12-buster-dev

.PHONY: test_node_10-stretch-base
test_node_10-stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:10-stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'
	@version=$$(docker run -it --rm krmcbride/node:10-stretch-base node --version); \
	echo expecting $(NODE_10_STRETCH_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_10_STRETCH_VERSION)

.PHONY: test_node_10-stretch-dev
test_node_10-stretch-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:10-stretch-dev cat /etc/issue | grep 'Debian GNU/Linux 9'
	@docker run -it --rm krmcbride/node:10-stretch-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm krmcbride/node:10-stretch-dev node --version); \
	echo expecting $(NODE_10_STRETCH_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_10_STRETCH_VERSION)

.PHONY: test_node_12-buster-base
test_node_12-buster-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:12-buster-base cat /etc/issue | grep 'Debian GNU/Linux 10'
	@version=$$(docker run -it --rm krmcbride/node:12-buster-base node --version); \
	echo expecting $(NODE_12_BUSTER_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_12_BUSTER_VERSION)

.PHONY: test_node_12-buster-dev
test_node_12-buster-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:12-buster-dev cat /etc/issue | grep 'Debian GNU/Linux 10'
	@docker run -it --rm krmcbride/node:12-buster-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm krmcbride/node:12-buster-dev node --version); \
	echo expecting $(NODE_12_BUSTER_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_12_BUSTER_VERSION)


.PHONY: test_java
test_java: \
	test_java_8-stretch-base \
	test_java_8-stretch-dev \
	test_corretto_8-amazonlinux2-base

.PHONY: test_java_8-stretch-base
test_java_8-stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/java:8-stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'
	@version=$$(docker run -it --rm \
		krmcbride/java:8-stretch-base \
		bash -c 'java -version 2>&1 | grep Environment | sed '\''s/1\.8\.0_/8u/'\'''); \
	echo expecting $(JAVA_8_STRETCH_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(JAVA_8_STRETCH_VERSION)

.PHONY: test_java_8-stretch-dev
test_java_8-stretch-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/java:8-stretch-dev cat /etc/issue | grep 'Debian GNU/Linux 9'
	@docker run -it --rm krmcbride/java:8-stretch-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm \
		krmcbride/java:8-stretch-dev \
		bash -c 'java -version 2>&1 | grep Environment | sed '\''s/1\.8\.0_/8u/'\'''); \
	echo expecting $(JAVA_8_STRETCH_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(JAVA_8_STRETCH_VERSION)

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
.PHONY: build_debian_buster-base
build_debian_buster-base:
	docker build -t krmcbride/debian:buster-base build/debian/buster-base/

.PHONY: build_debian_buster-dev
build_debian_buster-dev: build_debian_buster-base
	docker build -t krmcbride/debian:buster-dev build/debian/buster-dev/

.PHONY: build_java_8_stretch-base
build_java_8_stretch-base:
	docker build -t krmcbride/java:8-stretch-base build/java/8-stretch-base/


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

