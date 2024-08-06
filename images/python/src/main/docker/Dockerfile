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

RUN apt-get $APT_OPTIONS update \
    && DEBIAN_FRONTEND=noninteractive apt-get $APT_OPTIONS install --no-install-recommends -y \
      git \
      openssl \
      python${PYTHON_VERSION} \
      python${PYTHON_VERSION}-venv \
      libgomp1 \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/canonical/chisel/releases/download/v$CHISEL_VERSION/chisel_v${CHISEL_VERSION}_linux_$TARGETARCH.tar.gz chisel.tar.gz
ADD slices/ slices/
ADD files/ files/

ARG SLICES_DIR=/chisel-releases/slices/
RUN tar -xvf chisel.tar.gz -C /usr/bin/ \
    && git clone https://github.com/canonical/chisel-releases.git --branch ubuntu-$UBUNTU_VERSION --depth 1 /chisel-releases \
    && cd /chisel-releases \
    && git apply ../files/libpython${PYTHON_VERSION}-stdlib.yaml.patch  \
    && cd - \
    && cp -vRn slices $SLICES_DIR

WORKDIR /rootfs
RUN chisel cut --release /chisel-releases --root /rootfs $CHISEL_EXTRA_SLICES \
        base-files_base \
        base-files_release-info \
        bash_bins \
        ca-certificates_data \
        libstdc++6_libs \
        libgomp1_libs \
        openssl_config \
        python${PYTHON_VERSION}_standard \
        python${PYTHON_VERSION}-venv_ensurepip \
        python-pip-whl_wheels \
        python3-distutils_python3-8

RUN python${PYTHON_VERSION} -m venv --copies /opt/venv \
    && source /opt/venv/bin/activate \
    && python${PYTHON_VERSION} -m pip install wheel \
    && mkdir -p /rootfs/opt/venv/ \
    && cp -r /opt/venv/ /rootfs/opt/


FROM scratch
ARG PYTHON_VERSION
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --from=builder /rootfs /
