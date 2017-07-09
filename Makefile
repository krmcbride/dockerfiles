generate: base
base: alpine debian
alpine: base/alpine/3.4-dev/Dockerfile base/alpine/3.5-dev/Dockerfile base/alpine/3.6-dev/Dockerfile
debian: base/debian/jessie-dev/Dockerfile

base/alpine/%-dev/Dockerfile: base/alpine/Dockerfile.dev
	@echo "generating $@ from $<"
	@sed 's~^FROM.*$$~FROM krmcbride/alpine:'"$*"'-base~' "$<" > "$@"

base/debian/%-dev/Dockerfile: base/debian/Dockerfile.dev
	@echo "generating $@ from $<"
	@sed 's~^FROM.*$$~FROM krmcbride/debian:'"$*"'-base~' "$<" > "$@"

.PHONY: generate
