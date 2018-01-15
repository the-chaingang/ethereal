FROM golang:1.8-jessie

# TARGET={bootnode|fullnode|miningnode}
ENV TARGET=fullnode

RUN mkdir -p /opt/go-ethereum

RUN git clone https://github.com/ethereum/go-ethereum.git /opt/go-ethereum

WORKDIR /opt/go-ethereum

RUN make all

RUN mkdir /opt/target

WORKDIR /opt/target

RUN mkdir /opt/shared
VOLUME /opt/shared

RUN mkdir /opt/genesis
VOLUME /opt/genesis

COPY run.sh .

ENV NODE_NAME=""
ENV GENESIS_FILE="genesis.json"

ENTRYPOINT ["bash", "run.sh"]
CMD []
