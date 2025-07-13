FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV XWIN_ROOT=/xwin
ENV PATH="/root/.cargo/bin:$PATH"

COPY manifest.json /manifest.json
COPY cmake_win_toolchain.cmake /cmake_win_toolchain.cmake

RUN apt-get update && \
    apt-get install -y \
        cmake \
        ninja-build \
        lsb-release \
        software-properties-common \
        gnupg \
        curl \
        ca-certificates

RUN curl -fsSL https://apt.llvm.org/llvm.sh | bash -s -- 19 && \
    apt-get install -y clang-tools-19

RUN clang-cl-19 --version

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    node -v && npm -v

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable && \
    rustc --version && cargo --version

RUN set -eux; \
    cargo install xwin && \
    xwin --accept-license --manifest /manifest.json splat \
         --output "$XWIN_ROOT" \
         --use-winsysroot-style \
         --preserve-ms-arch-notation && \
    rm -rf ~/.cargo/registry ~/.cargo/git ~/.rustup .xwin-cache /manifest.json

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
