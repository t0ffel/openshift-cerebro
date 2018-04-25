FROM centos:centos7

MAINTAINER OpenShift Development <dev@lists.openshift.redhat.com>

EXPOSE 9000
USER 0

ENV HOME=/opt/app-root \
    JAVA_VER=1.8.0 \
    APP_VERSION=0.7.3 \
    CEREBRO_CONF=/etc/cerebro/config

RUN yum install -y --setopt=tsflags=nodocs \
                java-1.8.0-openjdk-headless unzip \
                && \
	yum update -y && \
    yum clean all

RUN mkdir -p ${HOME}
WORKDIR ${HOME}

ADD https://github.com/lmenezes/cerebro/releases/download/v${APP_VERSION}/cerebro-${APP_VERSION}.zip ${HOME}/

RUN cd ${HOME} && \
    unzip cerebro-${APP_VERSION}.zip && \
    chmod -R og+w ${HOME} && \
    mv cerebro-${APP_VERSION} cerebro && \
    rm cerebro-${APP_VERSION}.zip

COPY conf/* ${HOME}/cerebro/conf/

USER 1000

CMD ["/bin/bash", "/opt/app-root/cerebro/bin/cerebro"]
