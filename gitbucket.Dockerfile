FROM adoptopenjdk:8-jre-openj9

ARG VERSION

EXPOSE 8080 29418

LABEL maintainer="Hugh Jiang <jjqzy[at]foxmail.com>"

ARG GITBUCKET_DIST=/opt/gitbucket
ARG GITBUCKET_DATA_PATH=${GITBUCKET_DIST}/data

COPY gitbucket/run-gitbucket.sh /run-gitbucket.sh

RUN chmod +x /run-gitbucket.sh && \
    groupadd -g 1000 gitbucket && \
    useradd -r -u 1000 -g gitbucket -d ${GITBUCKET_DIST} gitbucket && \
    mkdir ${GITBUCKET_DIST} ${GITBUCKET_DATA_PATH} && \
    chown -R gitbucket:gitbucket ${GITBUCKET_DIST} ${GITBUCKET_DATA_PATH}

ADD --chown=gitbucket:gitbucket \
    https://github.com/gitbucket/gitbucket/releases/download/${VERSION}/gitbucket.war \
    ${GITBUCKET_DIST}/gitbucket.war

# Set max upload file size to 30MB
ENV GITBUCKET_MAXFILESIZE 31457280
# Set upload file timeout to 60s
ENV GITBUCKET_UPLOADTIMEOUT 60000
# Inherit envs from args
ENV GITBUCKET_DIST ${GITBUCKET_DIST}
ENV GITBUCKET_DATA_PATH ${GITBUCKET_DATA_PATH}

USER gitbucket:gitbucket

VOLUME $GITBUCKET_DATA_PATH

ENTRYPOINT ["/run-gitbucket.sh"]
