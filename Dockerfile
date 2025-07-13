FROM ubuntu:24.04

RUN apt-get update
RUN apt-get install -y cmake ninja-build
RUN apt-get install -y lsb-release wget software-properties-common gnupg

# install llvm 19
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 19 && \
    apt-get install -y clang-tools-19 && \
    rm llvm.sh

RUN clang-cl-19 --version

# install rust for xwin
RUN apt-get install -y curl
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:$PATH"
RUN rustc --version && cargo --version

COPY manifest.json /manifest.json

ENV XWIN_ROOT=/xwin

RUN set -eux; \
    cargo install xwin; \
    xwin --accept-license --manifest /manifest.json splat --output $XWIN_ROOT --use-winsysroot-style --preserve-ms-arch-notation; \
    # Remove unneeded files to reduce image size
    rm -rf .xwin-cache /usr/local/cargo/bin/xwin; \
    rm /manifest.json

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt install -y nodejs
RUN node -v && npm -v

COPY cmake_win_toolchain.cmake /cmake_win_toolchain.cmake
