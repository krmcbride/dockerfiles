SHELL = bash

DOCKER_VERSION=$$(version=$$(cat src/main/debian/Dockerfile.dev | grep 'DOCKER_VERSION='); version=$${version//DOCKER_VERSION=/}; echo $${version//[\" \\]/})
DOCKER_COMPOSE_VERSION=$$(version=$$(cat src/main/debian/Dockerfile.dev | grep 'DOCKER_COMPOSE_VERSION='); version=$${version//DOCKER_COMPOSE_VERSION=/}; echo $${version//[\" \\]/})
NODE_CARBON_VERSION=$$(version=$$(cat src/main/node/8-debian/Dockerfile.upstream | grep 'ENV NODE_VERSION '); echo $${version//ENV NODE_VERSION /})
NODE_DUBNIUM_VERSION=$$(version=$$(cat src/main/node/10-debian/Dockerfile.upstream | grep 'ENV NODE_VERSION '); echo $${version//ENV NODE_VERSION /})
JAVA_VERSION_DEBIAN=$$(version=$$(cat src/main/java/8-debian/Dockerfile.upstream | grep 'ENV JAVA_VERSION '); echo $${version//ENV JAVA_VERSION /})
PHP_5_VERSION=$$(version=$$(cat src/main/php/5.6apache-debian/Dockerfile.upstream | grep 'ENV PHP_VERSION '); echo $${version//ENV PHP_VERSION /})
PHP_7_VERSION=$$(version=$$(cat src/main/php/7.2apache-debian/Dockerfile.upstream | grep 'ENV PHP_VERSION '); echo $${version//ENV PHP_VERSION /})

.PHONY: all
all: \
	clean \
	base \
	java \
	php \
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
	build/java/8-stretch-base/Dockerfile \
	build/java/8-stretch-dev/Dockerfile

get_java_upstream:
	set -e; \
	curl -sSLo src/main/java/8-debian/Dockerfile.upstream \
	    https://raw.githubusercontent.com/docker-library/openjdk/master/8/jdk/Dockerfile

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
	build/node/8-stretch-base/Dockerfile \
	build/node/8-stretch-dev/Dockerfile \
	build/node/10-stretch-base/Dockerfile \
	build/node/10-stretch-dev/Dockerfile

get_node_upstream:
	set -e; \
	curl -sSLo src/main/node/8-debian/Dockerfile.upstream \
	    https://raw.githubusercontent.com/nodejs/docker-node/master/8/stretch/Dockerfile; \
	curl -sSLo src/main/node/8-debian/Dockerfile.buildpack \
	    https://raw.githubusercontent.com/docker-library/buildpack-deps/master/stretch/Dockerfile; \
	curl -sSLo src/main/node/10-debian/Dockerfile.upstream \
	    https://raw.githubusercontent.com/nodejs/docker-node/master/10/stretch/Dockerfile; \
	curl -sSLo src/main/node/10-debian/Dockerfile.buildpack \
	    https://raw.githubusercontent.com/docker-library/buildpack-deps/master/stretch/Dockerfile

build/node/8-stretch-base/Dockerfile: src/main/node/8-debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/node/8-debian/Dockerfile.upstream); \
	    buildpack=$$(cat src/main/node/8-debian/Dockerfile.buildpack); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    export buildpack=$${buildpack//FROM/\#FROM}; \
	    dockerize -template $<:$@

build/node/8-stretch-dev/Dockerfile: src/main/node/8-debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/node/8-debian/Dockerfile.upstream); \
	    buildpack=$$(cat src/main/node/8-debian/Dockerfile.buildpack); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    export buildpack=$${buildpack//FROM/\#FROM}; \
	    dockerize -template $<:$@

build/node/10-stretch-base/Dockerfile: src/main/node/10-debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/node/10-debian/Dockerfile.upstream); \
	    buildpack=$$(cat src/main/node/10-debian/Dockerfile.buildpack); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    export buildpack=$${buildpack//FROM/\#FROM}; \
	    dockerize -template $<:$@

build/node/10-stretch-dev/Dockerfile: src/main/node/10-debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/node/10-debian/Dockerfile.upstream); \
	    buildpack=$$(cat src/main/node/10-debian/Dockerfile.buildpack); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    export buildpack=$${buildpack//FROM/\#FROM}; \
	    dockerize -template $<:$@

##
## php
##
.PHONY: php
php: \
	build/php/5.6apache-jessie-base/Dockerfile \
	build/php/5.6apache-jessie-dev/Dockerfile \
	build/php/7.2apache-stretch-base/Dockerfile \
	build/php/7.2apache-stretch-dev/Dockerfile

get_php_upstream:
	set -e; \
	curl -sSLo src/resources/php/7.2/apache2-foreground \
	    https://raw.githubusercontent.com/docker-library/php/master/7.2/stretch/apache/apache2-foreground; \
	curl -sSLo src/resources/php/7.2/docker-php-entrypoint \
	    https://raw.githubusercontent.com/docker-library/php/master/7.2/stretch/apache/docker-php-entrypoint; \
	curl -sSLo src/resources/php/7.2/docker-php-ext-configure \
	    https://raw.githubusercontent.com/docker-library/php/master/7.2/stretch/apache/docker-php-ext-configure; \
	curl -sSLo src/resources/php/7.2/docker-php-ext-enable \
	    https://raw.githubusercontent.com/docker-library/php/master/7.2/stretch/apache/docker-php-ext-enable; \
	curl -sSLo src/resources/php/7.2/docker-php-ext-install \
	    https://raw.githubusercontent.com/docker-library/php/master/7.2/stretch/apache/docker-php-ext-install; \
	curl -sSLo src/resources/php/7.2/docker-php-source \
	    https://raw.githubusercontent.com/docker-library/php/master/7.2/stretch/apache/docker-php-source; \
	chmod +x src/resources/php/7.2/docker-php-* src/resources/php/7.2/apache2-foreground; \
	curl -sSLo src/main/php/7.2apache-debian/Dockerfile.upstream \
	    https://raw.githubusercontent.com/docker-library/php/master/7.2/stretch/apache/Dockerfile

build/php/5.6apache-jessie-base/Dockerfile: src/main/php/5.6apache-debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/php/5.6apache-debian/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    composer=$$(cat src/main/php/5.6apache-debian/Dockerfile.composer); \
	    export composer=$${composer//FROM/\#FROM}; \
	    dockerize -template $<:$@; \
	    cp -R src/resources/php/5.6/* $(@D)

build/php/5.6apache-jessie-dev/Dockerfile: src/main/php/5.6apache-debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/php/5.6apache-debian/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    composer=$$(cat src/main/php/5.6apache-debian/Dockerfile.composer); \
	    export composer=$${composer//FROM/\#FROM}; \
	    dockerize -template $<:$@; \
	    cp -R src/resources/php/5.6/* $(@D)

build/php/7.2apache-stretch-base/Dockerfile: src/main/php/7.2apache-debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/php/7.2apache-debian/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    composer=$$(cat src/main/php/7.2apache-debian/Dockerfile.composer); \
	    export composer=$${composer//FROM/\#FROM}; \
	    dockerize -template $<:$@; \
	    cp -R src/resources/php/7.2/* $(@D)

build/php/7.2apache-stretch-dev/Dockerfile: src/main/php/7.2apache-debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
	    upstream=$$(cat src/main/php/7.2apache-debian/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
	    composer=$$(cat src/main/php/7.2apache-debian/Dockerfile.composer); \
	    export composer=$${composer//FROM/\#FROM}; \
	    dockerize -template $<:$@; \
	    cp -R src/resources/php/7.2/* $(@D)


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
	test_php \
	test_java

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
	test_node_8-stretch-base \
	test_node_8-stretch-dev \
	test_node_10-stretch-base \
	test_node_10-stretch-dev

.PHONY: test_node_8-stretch-base
test_node_8-stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:8-stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'
	@version=$$(docker run -it --rm krmcbride/node:8-stretch-base node --version); \
	echo expecting $(NODE_CARBON_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_CARBON_VERSION)

.PHONY: test_node_8-stretch-dev
test_node_8-stretch-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:8-stretch-dev cat /etc/issue | grep 'Debian GNU/Linux 9'
	@docker run -it --rm krmcbride/node:8-stretch-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm krmcbride/node:8-stretch-dev node --version); \
	echo expecting $(NODE_CARBON_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_CARBON_VERSION)

.PHONY: test_node_10-stretch-base
test_node_10-stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:10-stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'
	@version=$$(docker run -it --rm krmcbride/node:10-stretch-base node --version); \
	echo expecting $(NODE_DUBNIUM_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_DUBNIUM_VERSION)

.PHONY: test_node_10-stretch-dev
test_node_10-stretch-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/node:10-stretch-dev cat /etc/issue | grep 'Debian GNU/Linux 9'
	@docker run -it --rm krmcbride/node:10-stretch-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm krmcbride/node:10-stretch-dev node --version); \
	echo expecting $(NODE_DUBNIUM_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(NODE_DUBNIUM_VERSION)

.PHONY: test_java
test_java: \
	test_java_8-stretch-base \
	test_java_8-stretch-dev

.PHONY: test_java_8-stretch-base
test_java_8-stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/java:8-stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'
	@version=$$(docker run -it --rm \
		krmcbride/java:8-stretch-base \
		bash -c 'java -version 2>&1 | grep Environment | sed '\''s/1\.8\.0_/8u/'\'''); \
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
		bash -c 'java -version 2>&1 | grep Environment | sed '\''s/1\.8\.0_/8u/'\'''); \
	echo expecting $(JAVA_VERSION_DEBIAN); \
	echo got $${version}; \
	echo $${version} | grep $(JAVA_VERSION_DEBIAN)

.PHONY: test_php
test_php: \
	test_php_5.6apache-jessie-base \
	test_php_5.6apache-jessie-dev \
	test_php_7.2apache-stretch-base \
	test_php_7.2apache-stretch-dev

.PHONY: test_php_5.6apache-jessie-base
test_php_5.6apache-jessie-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/php:5.6apache-jessie-base cat /etc/issue | grep 'Debian GNU/Linux 8'
	@version=$$(docker run -it --rm krmcbride/php:5.6apache-jessie-base php --version); \
	echo expecting $(PHP_5_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(PHP_5_VERSION)

.PHONY: test_php_5.6apache-jessie-dev
test_php_5.6apache-jessie-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/php:5.6apache-jessie-dev cat /etc/issue | grep 'Debian GNU/Linux 8'
	@docker run -it --rm krmcbride/php:5.6apache-jessie-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm krmcbride/php:5.6apache-jessie-dev php --version); \
	echo expecting $(PHP_5_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(PHP_5_VERSION)

.PHONY: test_php_7.2apache-stretch-base
test_php_7.2apache-stretch-base:
	@echo ===== running $@
	@docker run -it --rm krmcbride/php:7.2apache-stretch-base cat /etc/issue | grep 'Debian GNU/Linux 9'
	@version=$$(docker run -it --rm krmcbride/php:7.2apache-stretch-base php --version); \
	echo expecting $(PHP_7_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(PHP_7_VERSION)

.PHONY: test_php_7.2apache-stretch-dev
test_php_7.2apache-stretch-dev:
	@echo ===== running $@
	@docker run -it --rm krmcbride/php:7.2apache-stretch-dev cat /etc/issue | grep 'Debian GNU/Linux 9'
	@docker run -it --rm krmcbride/php:7.2apache-stretch-dev ls /usr/local/oh-my-zsh > /dev/null
	@version=$$(docker run -it --rm krmcbride/php:7.2apache-stretch-dev php --version); \
	echo expecting $(PHP_7_VERSION); \
	echo got $${version}; \
	echo $${version} | grep $(PHP_7_VERSION)


##
## Build (just for local testing, CI does not use these)
##
.PHONY: build_debian_stretch-base
build_debian_stretch-base:
	docker build -t krmcbride/debian:stretch-base build/debian/stretch-base/

.PHONY: build_debian_stretch-dev
build_debian_stretch-dev: build_debian_stretch-base
	docker build -t krmcbride/debian:stretch-dev build/debian/stretch-dev/

.PHONY: build_java_8_stretch-base
build_java_8_stretch-base:
	docker build -t krmcbride/java:8-stretch-base build/java/8-stretch-base/


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

.PHONY: push_ci_18.09_image
push_ci_18.09_image: build_ci_18.09_image
	docker push krmcbride/docker:18.09-ci

.PHONY: clean
clean:
	rm -rf build

