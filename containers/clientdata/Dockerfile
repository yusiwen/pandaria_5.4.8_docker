FROM debian:bullseye-slim as builder
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /dist
COPY dist/Data.zip .
RUN unzip Data.zip && rm -f Data.zip

FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /opt/server/data
COPY --from=builder /dist/ .
