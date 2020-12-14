FROM registry.gitlab.com/eventsflow/docker/dev:0.5.4-ubuntu

COPY assets/ /tmp/assets/

RUN echo '[INFO] Configure environment' && \
        /sbin/install.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
