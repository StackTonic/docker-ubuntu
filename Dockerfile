FROM ubuntu:focal

ARG BUILD_DATE
ARG VERSION=dev
ARG S6_OVERLAY_VERSION=3.1.0.1

LABEL build_version="StackTonic.au version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="HunterNyan"

# Disable frontend dialogs
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
HOME="/root" \
TERM="xterm"

#Update Container
RUN  echo "**** Update Container ****" && \
    apt-get update && \
    apt-get install -y xz-utils software-properties-common curl inetutils-syslogd && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/syslogd-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/syslogd-overlay-noarch.tar.xz

RUN \
  echo "**** create app user and make our folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false app && \
  usermod -G users app && \
  mkdir -p \
	/app \
	/config

COPY root/ /