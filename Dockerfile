FROM ghcr.io/linkerd/dev:v52

RUN whoami
RUN sudo apt upgrade

USER code
RUN curl -fsSL https://claude.ai/install.sh | bash

WORKDIR /home/code

COPY sandbox-scripts /tmp/sandbox-scripts
COPY build-scripts /tmp/build-scripts

RUN sudo install -o code -g code -m 0755 -d bin
RUN sudo install -o code -g code -m 0755 -t bin /tmp/sandbox-scripts/*
RUN sudo rm -rf /tmp/sandbox-scripts

RUN python3 /tmp/build-scripts/force-settings.py && sudo rm -rf /tmp/build-scripts

ENV PATH="/home/code/bin:/home/code/.local/bin:${PATH}"

RUN sudo mkdir /work
WORKDIR /work

ENTRYPOINT ["entrypoint.sh"]
