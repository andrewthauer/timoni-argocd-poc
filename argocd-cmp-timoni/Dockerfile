FROM alpine:3

ARG TIMONI_VERSION=0.19.0
ARG KUSTOMIZE_VERSION=5.3.0
ARG HELM_VERSION=3.14.0
ARG TARGET_ARCH=amd64

RUN apk update && apk add --no-cache \
    bash=5.2.21-r0 \
    curl=8.5.0-r0 \
    docker-credential-ecr-login=0.6.0-r15

# TODO: Integrity check before installing
RUN curl -Lo /tmp/timoni.tar.gz "https://github.com/stefanprodan/timoni/releases/download/v${TIMONI_VERSION}/timoni_${TIMONI_VERSION}_linux_amd64.tar.gz" \
    && tar -xzf /tmp/timoni.tar.gz -C /usr/local/bin \
    && rm /tmp/timoni.tar.gz

# TODO: Integrity check before installing
RUN curl -Lo /tmp/helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGET_ARCH}.tar.gz" \
    && mkdir /tmp/helm \
    && tar -zxvf /tmp/helm.tar.gz -C /tmp/helm \
    && cp /tmp/helm/linux-${TARGET_ARCH}/helm /usr/local/bin \
    && chmod +x /usr/local/bin/helm \
    && rm /tmp/helm.tar.gz && rm -rf /tmp/helm

# TODO: Integrity check before installing
RUN curl -Lo /tmp/kustomize.tar.gz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${TARGET_ARCH}.tar.gz" \
    && tar -xzf /tmp/kustomize.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/kustomize

RUN delgroup ping && \
    addgroup -g 998 ping && \
    adduser -D -u 999 argocd

USER argocd

RUN mkdir -p /home/argocd/.docker && \
    mkdir -p /home/argocd/cmp-server/config

COPY docker.json /home/argocd/.docker/config.json
COPY plugin.yaml /home/argocd/cmp-server/config/plugin.yaml
COPY init.sh /home/argocd/init.sh
COPY generate.sh /home/argocd/generate.sh

ENTRYPOINT [ "/var/run/argocd/argocd-cmp-server" ]
