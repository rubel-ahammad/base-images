ARG UBUNTU_VERSION
ARG TOMCAT_VERSION
ARG TOMCAT_BASE_IMAGE
ARG USER
ARG GROUP
ARG UID
ARG GID

FROM ubuntu:${UBUNTU_VERSION} as builder
ARG TOMCAT_VERSION
ARG USER
ARG GROUP
ARG UID
ARG GID

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN apt update \
    && apt install curl -y \
    && curl -o /tmp/tomcat.tar.gz https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && tar zxvf /tmp/tomcat.tar.gz -C /opt \
    && rm /tmp/tomcat.tar.gz \
    && mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat \
    && groupadd -g ${GID} ${GROUP} \
    && useradd -u ${UID} -g ${GID} -d /opt/tomcat ${USER} \
    && chown -R ${UID}:${GID} /opt/tomcat/* \
    && find /opt/tomcat/bin -type f -name "*.sh" -exec chmod +x {} \; \
    && rm -rf /opt/tomcat/webapps/*


FROM ${TOMCAT_BASE_IMAGE}
ARG USER
ARG GROUP
ARG UID
ARG GID

ENV CATALINA_HOME=/opt/tomcat
ENV PATH="$CATALINA_HOME/bin:$PATH"

COPY --from=builder --chown=$UID:$GID /opt/tomcat /opt/tomcat

EXPOSE 8080
ENTRYPOINT ["/opt/tomcat/bin/catalina.sh"]
CMD ["run"]
