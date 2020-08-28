FROM eventsflow-base:0.4.3-ubuntu

COPY assets/ /tmp/assets/

RUN echo '[INFO] Configure dev environment' && \
        /tmp/assets/sbin/dev-install.sh && \
    echo '[INFO] Configure environment' && \
        /sbin/install.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
