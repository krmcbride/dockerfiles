all: clean generate
generate: base
base: alpine debian
alpine: alpine_base alpine_dev
alpine_base: build/alpine/3.4-base/Dockerfile build/alpine/3.5-base/Dockerfile build/alpine/3.6-base/Dockerfile
alpine_dev: build/alpine/3.4-dev/Dockerfile build/alpine/3.5-dev/Dockerfile build/alpine/3.6-dev/Dockerfile
debian: debian_base debian_dev
debian_base: build/debian/8-base/Dockerfile
debian_dev: build/debian/8-dev/Dockerfile


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


# build_alpine_34_base:
# 	docker build -t krmcbride/alpine:3.4-base -f base/alpine/3.4-base/Dockerfile base/

# build_alpine_34_dev: build_alpine_34_base
# 	docker build -t krmcbride/alpine:3.4-dev -f base/alpine/3.4-dev/Dockerfile base/

# build_debian_jessie_base:
# 	docker build -t krmcbride/debian:jessie-base -f base/debian/jessie-base/Dockerfile base/

# build_debian_jessie_dev: build_debian_jessie_base
# 	docker build -t krmcbride/debian:jessie-dev -f base/debian/jessie-dev/Dockerfile base/

# test: build_alpine_34_dev build_debian_jessie_dev
# 	docker run -it --rm krmcbride/alpine:3.4-dev cat /etc/issue | grep 'Alpine Linux 3.4'
# 	docker run -it --rm krmcbride/debian:jessie-dev cat /etc/issue | grep 'Debian GNU/Linux 8'

clean:
	rm -rf build

.PHONY: all clean test
