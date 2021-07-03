DOCKER_BIN := $(shell which docker)

define github_latest_release
$(shell curl -sI https://github.com/$(1)/releases/latest | grep "^location:" | sed -r "s/.*\/tag\/(.*)/\1/g")
endef

.PHONY: all check gitbucket

all: gitbucket
	@echo "Done building all docker images"

check:
	@if [ -z $(DOCKER_BIN) ]; then \
	    echo "Docker not installed"; \
		exit 1; \
	fi

gitbucket: check gitbucket.Dockerfile
	$(eval VER=$(call github_latest_release,gitbucket/gitbucket))
	@echo "Building Docker image for GitBucket ${VER}"
	@${DOCKER_BIN} build -t gitbucket:${VER} \
					     -t gitbucket:latest \
						 --build-arg VERSION=${VER} \
						 -f gitbucket.Dockerfile \
						 .
