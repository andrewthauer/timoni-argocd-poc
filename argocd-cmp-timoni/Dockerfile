FROM alpine:3

ARG TIMONI_VERSION=0.19.0

RUN apk update && apk add --no-cache \
    bash=5.2.21-r0 \
    curl=8.5.0-r0 \
    docker-credential-ecr-login=0.6.0-r15

RUN curl -Lo /tmp/timoni.tar.gz "https://github.com/stefanprodan/timoni/releases/download/v${TIMONI_VERSION}/timoni_${TIMONI_VERSION}_linux_amd64.tar.gz" && \
    tar -xzf /tmp/timoni.tar.gz -C /usr/local/bin && \
    rm /tmp/timoni.tar.gz

RUN curl -fsSL -o get_helm.sh "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"

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
