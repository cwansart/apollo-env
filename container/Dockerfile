FROM debian:13-slim

ARG UID=1000
ARG GID=1000

RUN apt-get update && \
    apt-get install -y \
        # general \
        curl \
        # for gcc \
        build-essential \
        libgmp-dev \
        libmpfr-dev \
        libmpc-dev \
        flex \
        # for mpfr \
        automake \
        autoconf \
        libtool \
        texinfo \
        # for kernel headers
        rsync && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g $GID user && \
    useradd -u $UID -g $GID -m -s /bin/bash user

USER user

WORKDIR /apollo

