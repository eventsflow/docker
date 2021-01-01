FROM registry.gitlab.com/eventsflow/docker/dev:0.5.4-ubuntu

COPY assets/ /tmp/assets/

RUN echo '[INFO] Configure environment' && \
        /sbin/install.sh && \
    echo "[INFO] Configure Dev VSCode environment" && \
        /tmp/assets/bin/dev-vscode-install.sh

USER vscode
ENTRYPOINT ["/sbin/entrypoint.sh"]
