ARG UBUNTU_VERSION=20.04
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101
ARG JAVA_VERSION=21
ARG CHISEL_VERSION=0.10.0

FROM ubuntu:${UBUNTU_VERSION} as builder
ARG UBUNTU_VERSION
ARG USER
ARG UID
ARG GROUP
ARG GID
ARG JAVA_VERSION
ARG CHISEL_VERSION
ARG TARGETARCH

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN --mount=type=secret,id=pro-attach-config \
    apt-get update \
    # Required to talk to the Ubuntu Pro authentication server securely.
    && apt-get install --no-install-recommends -y ubuntu-advantage-tools ca-certificates \
    && pro attach --attach-config /run/secrets/pro-attach-config \
    # Always upgrade all packages with the Ubuntu Pro services enabled.
    && apt-get upgrade -y \
    && apt-get install -y ca-certificates-java \
      binutils \
      openjdk-${JAVA_VERSION}-jdk \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/canonical/chisel/releases/download/v$CHISEL_VERSION/chisel_v${CHISEL_VERSION}_linux_$TARGETARCH.tar.gz chisel.tar.gz
RUN tar -xvf chisel.tar.gz -C /usr/bin/

RUN jlink --no-header-files --no-man-pages --strip-debug \
    --add-modules \
java.base,java.datatransfer,java.desktop,java.instrument,\
java.logging,java.management,java.management.rmi,java.naming,\
java.prefs,java.rmi,java.security.sasl,java.xml,jdk.incubator.foreign,\
jdk.incubator.vector,jdk.internal.vm.ci,jdk.jfr,jdk.management,\
jdk.management.jfr,jdk.management.agent,jdk.net,jdk.nio.mapmode,\
jdk.sctp,jdk.unsupported,jdk.naming.rmi,java.se,java.net.http,\
java.scripting,java.security.jgss,java.smartcardio,java.sql,\
java.sql.rowset,java.transaction.xa,java.xml.crypto,jdk.accessibility,\
jdk.charsets,jdk.crypto.cryptoki,jdk.crypto.ec,jdk.dynalink,jdk.httpserver,\
jdk.jsobject,jdk.localedata,jdk.naming.dns,jdk.security.auth,\
jdk.security.jgss,jdk.xml.dom,jdk.zipfs,java.compiler,\
jdk.internal.vm.compiler,jdk.internal.vm.compiler.management,\
jdk.jdwp.agent \
    --output /opt/java

WORKDIR /opt/java
RUN tar zcvf legal.tar.gz legal && rm -r legal

RUN mkdir -p /rootfs \
    && chisel cut --root /rootfs \
        libc6_libs \
        libgcc-s1_libs \
        libstdc++6_libs \
        zlib1g_libs \
        libgraphite2-3_libs \
        libglib2.0-0_core \
        base-files_bin

RUN install -d -m 0755 -o $UID -g $GID /rootfs/home/$USER \
    && mkdir -p /rootfs/etc \
    && echo -e "root:x:0:\n$GROUP:x:$GID:" >/rootfs/etc/group \
    && echo -e "root:x:0:0:root:/root:/noshell\n$USER:x:$UID:$GID::/home/$USER:/noshell" >/rootfs/etc/passwd
RUN mkdir -p /rootfs/opt \
    && cp -r /opt/java/ /rootfs/opt/java/

FROM scratch
ARG USER
ARG UID
ARG GID
USER $UID:$GID

COPY --from=builder /rootfs /
# Workaround for https://github.com/moby/moby/issues/38710
COPY --from=builder --chown=$UID:$GID /rootfs/home/$USER /home/$USER
ENV JAVA_HOME /opt/java/
ENTRYPOINT ["/opt/java/bin/java"]