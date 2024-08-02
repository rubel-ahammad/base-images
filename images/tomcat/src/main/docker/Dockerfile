ARG UBUNTU_VERSION
ARG TOMCAT_VERSION
ARG JAVA_VERSION
ARG CHISEL_VERSION
ARG CHISEL_EXTRA_SLICES=""
ARG APT_OPTIONS=""

FROM ubuntu:${UBUNTU_VERSION} as builder
ARG UBUNTU_VERSION
ARG TARGETARCH
ARG TOMCAT_VERSION
ARG JAVA_VERSION
ARG CHISEL_VERSION
ARG CHISEL_EXTRA_SLICES
ARG APT_OPTIONS
ARG USER
ARG UID
ARG GROUP
ARG GID

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN --mount=type=secret,id=pro-attach-config \
    apt-get $APT_OPTIONS update \
    # Required to talk to the Ubuntu Pro authentication server securely.
    && apt-get  $APT_OPTIONS install --no-install-recommends -y ubuntu-advantage-tools ca-certificates \
    && pro attach --attach-config /run/secrets/pro-attach-config \
    # Always upgrade all packages with the Ubuntu Pro services enabled.
    && apt-get  $APT_OPTIONS upgrade -y

RUN apt-get $APT_OPTIONS update  \
    && apt-get $APT_OPTIONS install --no-install-recommends -y \
      ca-certificates-java \
      binutils \
      openjdk-${JAVA_VERSION}-jdk \
      openssl \
      curl \
      gosu \
      unzip \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/canonical/chisel/releases/download/v$CHISEL_VERSION/chisel_v${CHISEL_VERSION}_linux_$TARGETARCH.tar.gz chisel.tar.gz
RUN tar -xvf chisel.tar.gz -C /usr/bin/

RUN jlink --no-header-files --no-man-pages --strip-debug \
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
jdk.jdwp.agent,jdk.nio.mapmode \
    --output /opt/java

WORKDIR /opt/java
RUN tar zcvf legal.tar.gz legal && rm -r legal

RUN mkdir -p /rootfs \
    && chisel cut --release ubuntu-$UBUNTU_VERSION --root /rootfs $CHISEL_EXTRA_SLICES \
        base-files_base \
        base-files_release-info \
        bash_bins \
        ca-certificates_data \
        ca-certificates-java_data \
        coreutils_bins \
        dash_bins \
        libc6_libs \
        libgcc-s1_libs \
        libglib2.0-0_core \
        libgraphite2-3_libs \
        libstdc++6_libs \
        libbz2-1.0_libs \
        openssl_config \
        zlib1g_libs

RUN install -d -m 0755 -o $UID -g $GID /rootfs/var/lib/$USER \
    && mkdir -p /rootfs/etc \
    && echo -e "root:x:0:\n$GROUP:x:$GID:" >/rootfs/etc/group \
    && echo -e "root:x:0:0:root:/root:/noshell\n$USER:x:$UID:$GID::/var/lib/$USER:/noshell" >/rootfs/etc/passwd

RUN curl -o /tmp/tomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && tar zxvf /tmp/tomcat.tar.gz -C /opt \
    && rm /tmp/tomcat.tar.gz \
    && mv /opt/apache-tomcat-${TOMCAT_VERSION} /usr/local/tomcat \
    && find /usr/local/tomcat/bin -type f -name "*.sh" -exec chmod +x {} \; \
    && rm -rf /usr/local/tomcat/webapps/*

# No chisel available: gosu, unzip
RUN mkdir -p /rootfs/opt /rootfs/usr/local\
    && cp -r /opt/java/ /rootfs/opt/java/ \
    && cp -r /usr/local/tomcat/ /rootfs/usr/local/tomcat/ \
    && cp /bin/grep /rootfs/bin/grep \
    && cp /usr/bin/find /rootfs/usr/bin/find \
    && cp /usr/sbin/gosu /rootfs/usr/sbin/gosu \
    && cp /usr/bin/unzip /rootfs/usr/bin/unzip


FROM scratch

ENV JAVA_HOME=/opt/java/
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH="$CATALINA_HOME/bin:$JAVA_HOME/bin:$PATH"

COPY --from=builder /rootfs /
# Workaround for https://github.com/moby/moby/issues/38710
COPY --from=builder --chown=$UID:$GID /rootfs/var/lib/$USER /var/lib/$USER

EXPOSE 8080
ENTRYPOINT ["/usr/local/tomcat/bin/catalina.sh"]
CMD ["run"]
