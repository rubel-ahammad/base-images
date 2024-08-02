ARG UBUNTU_VERSION
ARG CHISEL_VERSION
ARG CHISEL_EXTRA_SLICES=""
ARG APT_OPTIONS=""

FROM ubuntu:${UBUNTU_VERSION} as builder
ARG UBUNTU_VERSION
ARG TARGETARCH
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

RUN apt-get update  \
    && apt-get $APT_OPTIONS install --no-install-recommends -y \
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
    libgomp1_libs \
    python3.10_core \
    python3.10_standard \
    python3.10-minimal_bins \
    python3.10-venv_ensurepip


FROM scratch
COPY --from=builder /rootfs /