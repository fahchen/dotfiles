FROM ubuntu:latest
LABEL maintainer="Phil Chen <06fahchen@gmail.com>"

ENV TERM xterm-256color

# Bootstrapping packages needed for installation
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq locales lsb-release \
  software-properties-common build-essential \
  curl git \
  lua5.3 liblua5.3-dev \
  perl libperl-dev && \
  apt-get clean

# Set locale to UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 && /usr/sbin/update-locale LANG=$LANG

# Install tools via Homebrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
COPY Brewfile .
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew bundle

RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

WORKDIR /root/test

# Setup dotfiles
COPY vimrc setup-*.sh install.sh .

RUN bash install.sh
