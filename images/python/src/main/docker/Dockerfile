ARG UBUNTU_VERSION
ARG PYTHON_VERSION
ARG CHISEL_VERSION
ARG CHISEL_EXTRA_SLICES=""
ARG APT_OPTIONS=""

FROM ubuntu:${UBUNTU_VERSION} as builder
ARG UBUNTU_VERSION
ARG TARGETARCH
ARG PYTHON_VERSION
ARG CHISEL_VERSION
ARG CHISEL_EXTRA_SLICES
ARG APT_OPTIONS

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN --mount=type=secret,id=pro-attach-config \
    apt-get $APT_OPTIONS update \
    # Required to talk to the Ubuntu Pro authentication server securely.
    && apt-get $APT_OPTIONS install --no-install-recommends -y ubuntu-advantage-tools ca-certificates \
    && pro attach --attach-config /run/secrets/pro-attach-config \
    # Always upgrade all packages with the Ubuntu Pro services enabled.
    && apt-get upgrade -y

RUN apt-get $APT_OPTIONS update  \
    && apt-get $APT_OPTIONS install --no-install-recommends -y \
      openssl \
      python3.10 \
      python3.10-venv \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/canonical/chisel/releases/download/v$CHISEL_VERSION/chisel_v${CHISEL_VERSION}_linux_$TARGETARCH.tar.gz chisel.tar.gz
RUN tar -xvf chisel.tar.gz -C /usr/bin/

WORKDIR /rootfs
RUN chisel cut --release ubuntu-$UBUNTU_VERSION --root /rootfs $CHISEL_EXTRA_SLICES \
    base-files_base \
    base-files_release-info \
    bash_bins \
    ca-certificates_data \
    libgomp1_libs \
    openssl_config \
    python${PYTHON_VERSION}_core \
    python${PYTHON_VERSION}_standard \
    python${PYTHON_VERSION}-minimal_bins \
    python${PYTHON_VERSION}-venv_ensurepip


FROM scratch
COPY --from=builder /rootfs /