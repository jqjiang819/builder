#!/bin/sh

# create temp directory if not exists
if [ ! -d /tmp/gitbucket ]; then
    mkdir /tmp/gitbucket
fi

java -jar $GITBUCKET_DIST/gitbucket.war --gitbucket.home=$GITBUCKET_DATA_PATH --temp_dir=/tmp/gitbucket