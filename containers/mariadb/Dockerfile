FROM mariadb:10.11
LABEL AUTHOR yusiwen@gmail.com

RUN apt-get update && apt-get -y install git unzip bzip2 && rm -rf /var/lib/apt/lists/*

COPY entry.sh /docker-entrypoint-initdb.d
RUN chmod 755 /docker-entrypoint-initdb.d/entry.sh

COPY backup.sh /backup
RUN chmod 755 /backup/backup.sh
