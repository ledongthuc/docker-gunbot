FROM bitnami/minideb:latest

ARG INSTALL_URL="https://github.com/GuntharDeNiro/BTCT/releases/download/2432/gunthy_linux.zip"
ARG HOST_FILE_PATH="./gunthy_linux.zip"
ARG DOCKER_BUILD_FILE_PATH="./lin.zip"
ARG DEBIAN_FRONTEND=noninteractive

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF org.label-schema.vcs-url="https://github.com/magicdude4eva/docker-gunbot"

## Setup Enviroment
ENV TZ=Europe/Vienna \
  TERM=xterm-256color \
  FORCE_COLOR=true \
  NPM_CONFIG_COLOR=always \
  MOCHA_COLORS=true \
  INSTALL_URL=${INSTALL_URL}

## Setup pre-requisites
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -y update && \
 apt-get install -y apt-utils

## Install additional libraries and upgrade
RUN apt-get -y upgrade && \
 apt-get install -y unzip curl fontconfig fonts-dejavu-extra ca-certificates && \
 apt-get clean -y && \
 apt-get autoclean -y && \
 apt-get autoremove -y

RUN update-ca-certificates --fresh

RUN fc-cache -fv

## Install Gunbot
WORKDIR /tmp
# RUN curl -Lo /tmp/${LOCAL_FILE_PATH} ${INSTALL_URL}
COPY ${HOST_FILE_PATH} ${DOCKER_BUILD_FILE_PATH}

RUN unzip -q ${DOCKER_BUILD_FILE_PATH} \
 && rm -rf ${DOCKER_BUILD_FILE_PATH} \
 && rm -rf __MACOSX \
 && mv gunthy_* /gunbot \
## && mv lin* /gunbot \
 && rm -f /gunbot/config.js \
 && rm -f /gunbot/tgconfig.json \
 && rm -f /gunbot/autoconfig.json \
 && chmod +x /gunbot/gunthy-linux

WORKDIR /gunbot

## COPY gunthy-linux /gunbot/
## RUN chmod +x /gunbot/gunthy-linux

EXPOSE 5000
VOLUME [ "/gunbot/backups", "/gunbot/logs", "/gunbot/json", "/gunbot/config.js", "/gunbot/gunbotgui.db"]

CMD /gunbot/gunthy-linux
