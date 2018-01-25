FROM debian:jessie

RUN mkdir -p /opt/runner /opt/tests /opt/signals

VOLUME /opt/tests
VOLUME /opt/signals

WORKDIR /opt/runner

COPY run.sh .

ENV TEST_SCRIPT=/opt/tests/test.sh
ENV SIGNAL_DIR=/opt/signals

ENTRYPOINT ["bash", "run.sh"]
CMD []
