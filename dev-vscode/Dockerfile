FROM registry.gitlab.com/eventsflow/docker/dev:0.6.3-ubuntu

COPY assets/ /tmp/assets/

RUN echo "[INFO] Configure Dev VSCode environment" && \
        /tmp/assets/sbin/dev-vscode-install.sh && \
    echo '[INFO] Configure environment' && \
        /sbin/install.sh

USER vscode
ENTRYPOINT ["/sbin/entrypoint.sh"]
