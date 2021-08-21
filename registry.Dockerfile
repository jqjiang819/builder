FROM golang:1.16-alpine3.14 AS registry-build

ENV GO111MODULE=auto
ENV DISTRIBUTION_DIR /go/src/github.com/docker/distribution
ENV BUILDTAGS include_oss include_gcs

ARG GOOS=linux
ARG GOARCH=amd64
ARG VERSION

RUN set -ex \
    && apk add --no-cache make git \
    && git config --global advice.detachedHead false \
    && git clone https://github.com/distribution/distribution.git -b v$VERSION $DISTRIBUTION_DIR \
    && cd $DISTRIBUTION_DIR && CGO_ENABLED=0 make PREFIX=/go clean binaries

FROM konradkleine/docker-registry-frontend:v2 AS frontend-image

FROM nginx:stable-alpine

EXPOSE 80

LABEL maintainer="Hugh Jiang <jjqzy[at]foxmail.com>"

ARG REGISTRY_BIN=/bin/registry

COPY --from=frontend-image /var/www/html /usr/share/nginx/html/
COPY --from=registry-build /go/src/github.com/docker/distribution/bin/registry $REGISTRY_BIN
COPY registry/html /usr/share/nginx/html/
COPY registry/config.yml /etc/docker/registry/config.yml
COPY registry/site.conf /etc/nginx/conf.d/default.conf
COPY registry/entrypoint.sh /entrypoint.sh

VOLUME ["/var/lib/registry"]

ENV ENV_REGISTRY_HOST=localhost
ENV ENV_REGISTRY_PORT=80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/docker/registry/config.yml"]
