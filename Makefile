all: clean generate
generate: base
base: alpine debian
alpine: alpine_base alpine_dev
alpine_base: base/alpine/3.4-base/Dockerfile base/alpine/3.5-base/Dockerfile base/alpine/3.6-base/Dockerfile
alpine_dev: base/alpine/3.4-dev/Dockerfile base/alpine/3.5-dev/Dockerfile base/alpine/3.6-dev/Dockerfile
debian: debian_base debian_dev
debian_base: base/debian/jessie-base/Dockerfile
debian_dev: base/debian/jessie-dev/Dockerfile


base/alpine/%-base/Dockerfile: base/alpine/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d "$(@D)" ] || mkdir -p "$(@D)"
	@sed 's~^FROM.*$$~FROM alpine:'"$*"'~' "$<" > "$@"

base/alpine/%-dev/Dockerfile: base/alpine/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d "$(@D)" ] || mkdir -p "$(@D)"
	@sed 's~^FROM.*$$~FROM krmcbride/alpine:'"$*"'-base~' "$<" > "$@"


base/debian/%-base/Dockerfile: base/debian/Dockerfile.base
	@echo "generating $@ from $<"
	@[ -d "$(@D)" ] || mkdir -p "$(@D)"
	@sed 's~^FROM.*$$~FROM debian:'"$*"'~' "$<" > "$@"

base/debian/%-dev/Dockerfile: base/debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@[ -d "$(@D)" ] || mkdir -p "$(@D)"
	@sed 's~^FROM.*$$~FROM krmcbride/debian:'"$*"'-base~' "$<" > "$@"

build_alpine_34_base:
	docker build -t krmcbride/alpine:3.4-base -f base/alpine/3.4-base/Dockerfile base/

build_alpine_34_dev: build_alpine_34_base
	docker build -t krmcbride/alpine:3.4-dev -f base/alpine/3.4-dev/Dockerfile base/

build_debian_jessie_base:
	docker build -t krmcbride/debian:jessie-base -f base/debian/jessie-base/Dockerfile base/

build_debian_jessie_dev: build_debian_jessie_base
	docker build -t krmcbride/debian:jessie-dev -f base/debian/jessie-dev/Dockerfile base/

test: build_alpine_34_dev build_debian_jessie_dev
	docker run -it --rm krmcbride/alpine:3.4-dev cat /etc/issue | grep 'Alpine Linux 3.4'
	docker run -it --rm krmcbride/debian:jessie-dev cat /etc/issue | grep 'Debian GNU/Linux 8'

clean:
	rm -rf base/*/*-dev base/*/*-base

.PHONY: all clean test
