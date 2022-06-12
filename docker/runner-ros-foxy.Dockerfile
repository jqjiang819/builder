FROM ros:foxy

RUN apt-get update && apt-get install -y \
        curl python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash buildbot

USER buildbot
WORKDIR /home/buildbot

ARG VERSION
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v$VERSION/actions-runner-linux-x64-$VERSION.tar.gz && \
    tar xzf ./actions-runner.tar.gz && \
    rm ./actions-runner.tar.gz

COPY runners/ros/start.sh .

CMD [ "./start.sh" ]
