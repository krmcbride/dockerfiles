SHELL = bash

DOCKER_VERSION=$$(version=$$(cat src/main/debian/Dockerfile.dev | grep 'DOCKER_VERSION='); version=$${version//DOCKER_VERSION=/}; echo $${version//[\" \\]/})
DOCKER_COMPOSE_VERSION=$$(version=$$(cat src/main/debian/Dockerfile.dev | grep 'DOCKER_COMPOSE_VERSION='); version=$${version//DOCKER_COMPOSE_VERSION=/}; echo $${version//[\" \\]/})
NODE_VERSION=$$(version=$$(cat src/main/node/6-debian/Dockerfile.upstream | grep 'ENV NODE_VERSION '); echo $${version//ENV NODE_VERSION /})
JAVA_VERSION_DEBIAN=$$(version=$$(cat src/main/java/8-debian/Dockerfile.upstream | grep 'ENV JAVA_VERSION '); echo $${version//ENV JAVA_VERSION /})
JAVA_VERSION_ALPINE=$$(version=$$(cat src/main/java/8-alpine/Dockerfile.upstream | grep 'ENV JAVA_VERSION '); echo $${version//ENV JAVA_VERSION /})
PHP_VERSION=$$(version=$$(cat src/main/php/5.6apache-debian/Dockerfile.upstream | grep 'ENV PHP_VERSION '); echo $${version//ENV PHP_VERSION /})

.PHONY: all
all: \
	clean \
	base \
	java \
	php \
	node

.PHONY: base
base: alpine debian

##
## alpine
##
.PHONY: alpine
alpine: alpine_base alpine_dev

.PHONY: alpine_base
alpine_base: \
	build/alpine/3.4-base/Dockerfile \
	build/alpine/3.5-base/Dockerfile \
	build/alpine/3.6-base/Dockerfile

.PHONY: alpine_dev
alpine_dev: \
	build/alpine/3.4-dev/Dockerfile \
	build/alpine/3.5-dev/Dockerfile \
	build/alpine/3.6-dev/Dockerfile

build/alpine/%-base/Dockerfile: src/main/alpine/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@export version=$*; dockerize -template $<:$@
	@cp -R src/resources/* $(@D)

build/alpine/%-dev/Dockerfile: src/main/alpine/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@export version=$*; dockerize -template $<:$@
	@cp -R src/resources/* $(@D)

##
## debian
##
.PHONY: debian
debian: debian_base debian_dev

.PHONY: debian_base
debian_base: \
	build/debian/jessie-base/Dockerfile \
	build/debian/stretch-base/Dockerfile

.PHONY: debian_dev
debian_dev: \
	build/debian/jessie-dev/Dockerfile \
	build/debian/stretch-dev/Dockerfile

build/debian/%-base/Dockerfile: src/main/debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@export version=$*; dockerize -template $<:$@
	@cp -R src/resources/* $(@D)

build/debian/%-dev/Dockerfile: src/main/debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@export version=$*; dockerize -template $<:$@
	@cp -R src/resources/* $(@D)

##
## java
##
.PHONY: java
java: \
	build/java/8-alpine3.6-base/Dockerfile \
	build/java/8-alpine3.6-dev/Dockerfile \
	build/java/8-stretch-base/Dockerfile \
	build/java/8-stretch-dev/Dockerfile

get_java_upstream:
	set -e; \
	curl -sSLo src/main/java/8-alpine/Dockerfile.upstream \
	    https://raw.githubusercontent.com/docker-library/openjdk/master/8-jdk/alpine/Dockerfile; \
	curl -sSLo src/main/java/8-debian/Dockerfile.upstream \
	    https://raw.githubusercontent.com/docker-library/openjdk/master/8-jdk/Dockerfile

build/java/8-alpine3.6-base/Dockerfile: src/main/java/8-alpine/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/java/8-alpine/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    dockerize -template $<:$@

build/java/8-alpine3.6-dev/Dockerfile: src/main/java/8-alpine/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/java/8-alpine/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    dockerize -template $<:$@

build/java/8-stretch-base/Dockerfile: src/main/java/8-debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/java/8-debian/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    dockerize -template $<:$@

build/java/8-stretch-dev/Dockerfile: src/main/java/8-debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/java/8-debian/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    dockerize -template $<:$@

##
## node
##
.PHONY: node
node: \
	build/node/6-jessie-base/Dockerfile \
	build/node/6-jessie-dev/Dockerfile

get_node_upstream:
	set -e; \
	curl -sSLo src/main/node/6-debian/Dockerfile.upstream \
	    https://raw.githubusercontent.com/nodejs/docker-node/master/6/Dockerfile; \
	curl -sSLo src/main/node/6-debian/Dockerfile.buildpack \
	    https://raw.githubusercontent.com/docker-library/buildpack-deps/master/jessie/Dockerfile

build/node/6-jessie-base/Dockerfile: src/main/node/6-debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/node/6-debian/Dockerfile.upstream); \
	    buildpack=$$(cat src/main/node/6-debian/Dockerfile.buildpack); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    export buildpack=$${buildpack//FROM/\#FROM}; \
	    dockerize -template $<:$@

build/node/6-jessie-dev/Dockerfile: src/main/node/6-debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/node/6-debian/Dockerfile.upstream); \
	    buildpack=$$(cat src/main/node/6-debian/Dockerfile.buildpack); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    export buildpack=$${buildpack//FROM/\#FROM}; \
	    dockerize -template $<:$@

##
## php
##
.PHONY: php
php: \
	build/php/5.6apache-jessie-base/Dockerfile \
	build/php/5.6apache-jessie-dev/Dockerfile

get_php_upstream:
	set -e; \
	curl -sSLo src/resources/php/5.6/apache2-foreground \
	    https://raw.githubusercontent.com/docker-library/php/master/5.6/jessie/apache/apache2-foreground; \
	curl -sSLo src/resources/php/5.6/docker-php-entrypoint \
	    https://raw.githubusercontent.com/docker-library/php/master/5.6/jessie/apache/docker-php-entrypoint; \
	curl -sSLo src/resources/php/5.6/docker-php-ext-configure \
	    https://raw.githubusercontent.com/docker-library/php/master/5.6/jessie/apache/docker-php-ext-configure; \
	curl -sSLo src/resources/php/5.6/docker-php-ext-enable \
	    https://raw.githubusercontent.com/docker-library/php/master/5.6/jessie/apache/docker-php-ext-enable; \
	curl -sSLo src/resources/php/5.6/docker-php-ext-install \
	    https://raw.githubusercontent.com/docker-library/php/master/5.6/jessie/apache/docker-php-ext-install; \
	curl -sSLo src/resources/php/5.6/docker-php-source \
	    https://raw.githubusercontent.com/docker-library/php/master/5.6/jessie/apache/docker-php-source; \
	chmod +x src/resources/php/5.6/docker-php-* src/resources/php/5.6/apache2-foreground; \
	curl -sSLo src/main/php/5.6apache-debian/Dockerfile.upstream \
	    https://raw.githubusercontent.com/docker-library/php/master/5.6/jessie/apache/Dockerfile

build/php/5.6apache-jessie-base/Dockerfile: src/main/php/5.6apache-debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/php/5.6apache-debian/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    dockerize -template $<:$@; \
	    cp -R src/resources/php/5.6/* $(@D)

build/php/5.6apache-jessie-dev/Dockerfile: src/main/php/5.6apache-debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/php/5.6apache-debian/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    dockerize -template $<:$@; \
	    cp -R src/resources/php/5.6/* $(@D)


##
## CI image
##
.PHONY: build_ci_17.06_image 
build_ci_17.06_image: build/docker/17.06-ci/Dockerfile
	docker pull krmcbride/docker:17.06-ci || true
	docker build --pull --cache-from krmcbride/docker:17.06-ci -t krmcbride/docker:17.06-ci $(<D)

build/docker/17.06-ci/Dockerfile: src/main/docker/17.06-ci/Dockerfile
	@[ -d $(@D) ] || mkdir -p $(@D)
	@cp $< $@

.PHONY: build_ci_17.09_image 
build_ci_17.09_image: build/docker/17.09-ci/Dockerfile
	docker pull krmcbride/docker:17.09-ci || true
	docker build --pull --cache-from krmcbride/docker:17.09-ci -t krmcbride/docker:17.09-ci $(<D)

build/docker/17.09-ci/Dockerfile: src/main/docker/17.09-ci/Dockerfile
	@[ -d $(@D) ] || mkdir -p $(@D)
	@cp $< $@


##
## Testing
##
.PHONY: test
test: \
	test_alpine \
	test_debian \
	test_node \
	test_php \
	test_java

.PHONY: test_alpine
test_alpine: \
	test_alpine_3.4-base \
	test_alpine_3.4-dev \
	test_alpine_3.6-base \
	test_alpine_3.6-dev

.PHONY: test_alpine_3.4-base
test_alpine_3.4-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/alpine:3.4-base cat /etc/issue | grep 'Alpine Linux 3.4'

.PHONY: test_alpine_3.4-dev
test_alpine_3.4-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/alpine:3.4-dev cat /etc/issue | grep 'Alpine Linux 3.4'
	@docker run -it --rm krmcbride/alpine:3.4-dev ls /usr/local/oh-my-zsh > /dev/null

.PHONY: test_alpine_3.6-base
test_alpine_3.6-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/alpine:3.6-base cat /etc/issue | grep 'Alpine Linux 3.6'

.PHONY: test_alpine_3.6-dev
test_alpine_3.6-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/alpine:3.6-dev cat /etc/issue | grep 'Alpine Linux 3.6'
	@docker run -it --rm krmcbride/alpine:3.6-dev ls /usr/local/oh-my-zsh > /dev/null

.PHONY: test_debian
test_debian: \
	test_debian_jessie-base \
	test_debian_jessie-dev \
	test_debian_stretch-base \
	test_debian_stretch-dev

.PHONY: test_debian_jessie-base
test_debian_jessie-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:jessie-base cat /etc/issue | grep 'Debian GNU/Linux 8'

.PHONY: test_debian_jessie-dev
test_debian_jessie-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:jessie-dev cat /etc/issue | grep 'Debian GNU/Linux 8'
	@docker run -it --rm krmcbride/debian:jessie-dev ls /usr/local/oh-my-zsh > /dev/null

.PHONY: test_debian_stretch-base
test_debian_stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'

.PHONY: test_debian_stretch-dev
test_debian_stretch-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/debian:stretch-dev cat /etc/issue | grep 'Debian GNU/Linux 9'
	@docker run -it --rm krmcbride/debian:stretch-dev ls /usr/local/oh-my-zsh > /dev/null

.PHONY: test_node
test_node: \
	test_node_6-jessie-base \
	test_node_6-jessie-dev

.PHONY: test_node_6-jessie-base
test_node_6-jessie-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:6-jessie-base cat /etc/issue | grep 'Debian GNU/Linux 8'
	@version=$$(docker run -it --rm krmcbride/node:6-jessie-base node --version); \
	echo expecting $(NODE_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_VERSION)

.PHONY: test_node_6-jessie-dev
test_node_6-jessie-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:6-jessie-dev cat /etc/issue | grep 'Debian GNU/Linux 8'
	@docker run -it --rm krmcbride/node:6-jessie-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm krmcbride/node:6-jessie-dev node --version); \
	echo expecting $(NODE_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_VERSION)

.PHONY: test_java
test_java: \
	test_java_8-alpine3.6-base \
	test_java_8-alpine3.6-dev \
	test_java_8-stretch-base \
	test_java_8-stretch-dev

.PHONY: test_java_8-alpine3.6-base
test_java_8-alpine3.6-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/java:8-alpine3.6-base cat /etc/issue | grep 'Alpine Linux 3.6'
	@version=$$(docker run -it --rm \
		krmcbride/java:8-alpine3.6-base \
		bash -c 'java -version 2>&1 | grep version | sed '\''s/openjdk version//; s/"//g; s/1\.//; s/\.0//; s/\([0-9]\)_\([0-9]\+\)/\1u\2/'\'''); \
	echo expecting $(JAVA_VERSION_ALPINE); \
	echo got $${version}; \
	echo $${version} | grep $(JAVA_VERSION_ALPINE)

.PHONY: test_java_8-alpine3.6-dev
test_java_8-alpine3.6-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/java:8-alpine3.6-dev cat /etc/issue | grep 'Alpine Linux 3.6'
	@docker run -it --rm krmcbride/java:8-alpine3.6-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm \
		krmcbride/java:8-alpine3.6-dev \
		bash -c 'java -version 2>&1 | grep version | sed '\''s/openjdk version//; s/"//g; s/1\.//; s/\.0//; s/\([0-9]\)_\([0-9]\+\)/\1u\2/'\'''); \
	echo expecting $(JAVA_VERSION_ALPINE); \
	echo got $${version}; \
	echo $${version} | grep $(JAVA_VERSION_ALPINE)

.PHONY: test_java_8-stretch-base
test_java_8-stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/java:8-stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'
	@version=$$(docker run -it --rm \
		krmcbride/java:8-stretch-base \
		bash -c 'java -version 2>&1 | grep version | sed '\''s/openjdk version//; s/"//g; s/1\.//; s/\.0//; s/\([0-9]\)_\([0-9]\+\)/\1u\2/'\'''); \
	echo expecting $(JAVA_VERSION_DEBIAN); \
	echo got $${version}; \
	echo $${version} | grep $(JAVA_VERSION_DEBIAN)

.PHONY: test_java_8-stretch-dev
test_java_8-stretch-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/java:8-stretch-dev cat /etc/issue | grep 'Debian GNU/Linux 9'
	@docker run -it --rm krmcbride/java:8-stretch-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm \
		krmcbride/java:8-stretch-dev \
		bash -c 'java -version 2>&1 | grep version | sed '\''s/openjdk version//; s/"//g; s/1\.//; s/\.0//; s/\([0-9]\)_\([0-9]\+\)/\1u\2/'\'''); \
	echo expecting $(JAVA_VERSION_DEBIAN); \
	echo got $${version}; \
	echo $${version} | grep $(JAVA_VERSION_DEBIAN)

.PHONY: test_php
test_php: \
	test_php_5.6apache-jessie-base \
	test_php_5.6apache-jessie-dev

.PHONY: test_php_5.6apache-jessie-base
test_php_5.6apache-jessie-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/php:5.6apache-jessie-base cat /etc/issue | grep 'Debian GNU/Linux 8'
	@version=$$(docker run -it --rm krmcbride/php:5.6apache-jessie-base php --version); \
	echo expecting $(PHP_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(PHP_VERSION)

.PHONY: test_php_5.6apache-jessie-dev
test_php_5.6apache-jessie-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/php:5.6apache-jessie-dev cat /etc/issue | grep 'Debian GNU/Linux 8'
	@docker run -it --rm krmcbride/php:5.6apache-jessie-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm krmcbride/php:5.6apache-jessie-dev php --version); \
	echo expecting $(PHP_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(PHP_VERSION)


##
## Build (just for local testing, CI does not use these)
##
.PHONY: build_alpine_3.6-base
build_alpine_3.6-base:
	docker build -t krmcbride/alpine:3.6-base build/alpine/3.6-base/

.PHONY: build_alpine_3.6-dev
build_alpine_3.6-dev: build_alpine_3.6-base
	docker build -t krmcbride/alpine:3.6-dev build/alpine/3.6-dev/

.PHONY: build_debian_stretch-base
build_debian_stretch-base:
	docker build -t krmcbride/debian:stretch-base build/debian/stretch-base/

.PHONY: build_debian_stretch-dev
build_debian_stretch-dev: build_debian_stretch-base
	docker build -t krmcbride/debian:stretch-dev build/debian/stretch-dev/


##
## Plumbing
##
.PHONY: get_upstreams
get_upstreams: \
	get_docker_upstream \
	get_java_upstream \
	get_node_upstream \
	get_php_upstream

get_docker_upstream:
	set -e; \
	echo "Docker version is $(DOCKER_VERSION)"; \
	curl -sSLo src/resources/omz-custom/plugins/docker/_docker \
	    https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker; \
	echo "Docker Compose version is $(DOCKER_COMPOSE_VERSION)"; \
	curl -sSLo src/resources/omz-custom/plugins/docker-compose/_docker_compose \
	    https://raw.githubusercontent.com/docker/compose/$(DOCKER_COMPOSE_VERSION)/contrib/completion/zsh/_docker-compose

.PHONY: push_ci_17.06_image
push_ci_17.06_image: build_ci_17.06_image
	docker push krmcbride/docker:17.06-ci

.PHONY: push_ci_17.09_image
push_ci_17.09_image: build_ci_17.09_image
	docker push krmcbride/docker:17.09-ci

.PHONY: clean
clean:
	rm -rf build

