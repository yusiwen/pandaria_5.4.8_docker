FROM mariadb:latest

RUN apt-get update && apt-get -y install git unzip && rm -rf /var/lib/apt/lists/*

COPY entry.sh /docker-entrypoint-initdb.d
RUN chmod 755 /docker-entrypoint-initdb.d/entry.sh
