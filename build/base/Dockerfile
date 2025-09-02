FROM ubuntu:25.04

RUN apt-get update && \
    apt-get install -y \
        # general \
        git \
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
        texinfo && \
    rm -rf /var/lib/apt/lists/*
