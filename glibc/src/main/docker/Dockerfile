ARG UBUNTU_RELEASE=20.04

FROM ubuntu:${UBUNTU_RELEASE}

RUN --mount=type=secret,id=pro-attach-config \
    apt-get update \
    # Required to talk to the Ubuntu Pro authentication server securely.
    && apt-get install --no-install-recommends -y ubuntu-advantage-tools ca-certificates \
    && pro attach --attach-config /run/secrets/pro-attach-config \
    # Always upgrade all packages with the Ubuntu Pro services enabled.
    && apt-get upgrade -y \
    # Install required applications here, while Ubuntu Pro is enabled
    && apt-get install -y openssl \
    # Finally, we clean up
    && apt-get purge --auto-remove -y ubuntu-advantage-tools \
    && rm -rf /var/lib/apt/lists/*