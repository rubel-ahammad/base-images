ARG UBUNTU_VERSION
ARG JAVA_VERSION
ARG CHISEL_VERSION
ARG CHISEL_EXTRA_SLICES=""
ARG APT_OPTIONS=""

FROM ubuntu:${UBUNTU_VERSION} as builder
ARG UBUNTU_VERSION
ARG TARGETARCH
ARG JAVA_VERSION
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
    && apt-get $APT_OPTIONS upgrade -y

RUN apt-get $APT_OPTIONS update  \
    && DEBIAN_FRONTEND=noninteractive TZ=UTC apt-get $APT_OPTIONS install --no-install-recommends -y \
      ca-certificates-java \
      binutils \
      openjdk-${JAVA_VERSION}-jdk \
      openssl \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/canonical/chisel/releases/download/v$CHISEL_VERSION/chisel_v${CHISEL_VERSION}_linux_$TARGETARCH.tar.gz chisel.tar.gz
RUN tar -xvf chisel.tar.gz -C /usr/bin/

RUN JAVA_EXTRA_MODULES=$([ ! "$JAVA_VERSION" == "11" ] && echo "jdk.nio.mapmode" || echo "") \
    jlink --no-header-files --no-man-pages --strip-debug \
    --add-modules \
java.base,java.datatransfer,java.instrument,\
java.logging,java.management,java.management.rmi,java.naming,\
java.prefs,java.rmi,java.security.sasl,java.xml,\
jdk.internal.vm.ci,jdk.jfr,jdk.management,\
jdk.management.jfr,jdk.management.agent,jdk.net,\
jdk.sctp,jdk.unsupported,jdk.naming.rmi,java.se,java.net.http,\
java.scripting,java.security.jgss,java.smartcardio,java.sql,\
java.sql.rowset,java.transaction.xa,java.xml.crypto,jdk.accessibility,\
jdk.charsets,jdk.crypto.cryptoki,jdk.crypto.ec,jdk.dynalink,jdk.httpserver,\
jdk.jsobject,jdk.localedata,jdk.naming.dns,jdk.security.auth,\
jdk.security.jgss,jdk.xml.dom,jdk.zipfs,java.compiler,\
jdk.internal.vm.compiler,jdk.internal.vm.compiler.management,\
jdk.jdwp.agent${JAVA_EXTRA_MODULES:+,$JAVA_EXTRA_MODULES} \
    --output /opt/java

WORKDIR /opt/java
RUN tar zcvf legal.tar.gz legal && rm -r legal

RUN mkdir -p /rootfs \
    && chisel cut --release ubuntu-$UBUNTU_VERSION --root /rootfs $CHISEL_EXTRA_SLICES \
        base-files_base \
        base-files_release-info \
        ca-certificates_data \
        ca-certificates-java_data \
        libc6_libs \
        libgcc-s1_libs \
        libglib2.0-0_core \
        libgraphite2-3_libs \
        libstdc++6_libs \
        openssl_config \
        zlib1g_libs

RUN mkdir -p /rootfs/opt \
    && cp -r /opt/java/ /rootfs/opt/java/


FROM scratch

COPY --from=builder /rootfs /

ENV JAVA_HOME=/opt/java/
ENV PATH="$JAVA_HOME/bin:$PATH"
ENTRYPOINT ["/opt/java/bin/java"]