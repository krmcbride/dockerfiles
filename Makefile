SHELL = bash

.PHONY: all
all: \
	clean \
	base \
	java

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
	build/debian/8-base/Dockerfile

.PHONY: debian_dev
debian_dev: \
	build/debian/8-dev/Dockerfile

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
	build/java/8-alpine-base/Dockerfile \
	build/java/8-alpine-dev/Dockerfile

java_get_upstream:
	curl -sSLo src/main/java/8-alpine/Dockerfile.upstream \
	    https://raw.githubusercontent.com/docker-library/openjdk/238cc35696423794b1951fc63d4cc9ffb8ca9685/8-jdk/alpine/Dockerfile

build/java/8-alpine-base/Dockerfile: src/main/java/8-alpine/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
		upstream=$$(cat src/main/java/8-alpine/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
		dockerize -template $<:$@

build/java/8-alpine-dev/Dockerfile: src/main/java/8-alpine/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d $(@D) ] || mkdir -p $(@D)
	@\
		upstream=$$(cat src/main/java/8-alpine/Dockerfile.upstream); \
	    export upstream=$${upstream//FROM/\#FROM}; \
		dockerize -template $<:$@


##
## CI image
##
.PHONY: build_ci_image 
build_ci_image: build/docker/17.03-ci/Dockerfile
	docker build -t krmcbride/docker:17.03-ci $(<D)

build/docker/17.03-ci/Dockerfile: src/main/docker/17.03-ci/Dockerfile
	@[ -d $(@D) ] || mkdir -p $(@D)
	@cp $< $@


.PHONY: build_alpine_34_base
build_alpine_34_base:
	docker build -t krmcbride/alpine:3.4-base build/alpine/3.4-base/

.PHONY: build_alpine_34_dev
build_alpine_34_dev: build_alpine_34_base
	docker build -t krmcbride/alpine:3.4-dev build/alpine/3.4-dev/

.PHONY: build_debian_8_base
build_debian_8_base:
	docker build -t krmcbride/debian:8-base build/debian/8-base/

.PHONY: build_debian_8_dev
build_debian_8_dev: build_debian_8_base
	docker build -t krmcbride/debian:8-dev build/debian/8-dev/

.PHONY: push_ci_image
push_ci_image: build_ci_image
	docker push krmcbride/docker:17.03-ci

.PHONY: test
test: build_alpine_34_dev build_debian_8_dev
	docker run -it --rm krmcbride/alpine:3.4-dev cat /etc/issue | grep 'Alpine Linux 3.4'
	docker run -it --rm krmcbride/alpine:3.4-dev ls /usr/local/bash-it > /dev/null
	docker run -it --rm krmcbride/debian:8-dev cat /etc/issue | grep 'Debian GNU/Linux 8'
	docker run -it --rm krmcbride/debian:8-dev ls /usr/local/bash-it > /dev/null

.PHONY: clean
clean:
	rm -rf build

