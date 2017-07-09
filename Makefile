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


clean:
	rm -rf base/*/*-dev base/*/*-base

.PHONY: all clean test
