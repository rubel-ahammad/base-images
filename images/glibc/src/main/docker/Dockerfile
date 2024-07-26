ARG UBUNTU_VERSION=22.04
ARG CHISEL_VERSION=0.10.0

FROM ubuntu:${UBUNTU_VERSION} as builder
ARG UBUNTU_VERSION
ARG CHISEL_VERSION
ARG TARGETARCH

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN --mount=type=secret,id=pro-attach-config \
    apt-get update \
    # Required to talk to the Ubuntu Pro authentication server securely.
    && apt-get install --no-install-recommends -y ubuntu-advantage-tools ca-certificates \
    && pro attach --attach-config /run/secrets/pro-attach-config \
    # Always upgrade all packages with the Ubuntu Pro services enabled.
    && apt-get upgrade -y

RUN apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/canonical/chisel/releases/download/v$CHISEL_VERSION/chisel_v${CHISEL_VERSION}_linux_$TARGETARCH.tar.gz chisel.tar.gz
RUN tar -xvf chisel.tar.gz -C /usr/bin/

WORKDIR /rootfs
RUN chisel cut --release ubuntu-$UBUNTU_VERSION --root /rootfs \
    base-files_base \
    base-files_release-info \
    ca-certificates_data \
    libgcc-s1_libs \
    libc6_libs \
    openssl_config \
    zlib1g_libs

FROM scratch
COPY --from=builder /rootfs /