FROM debian:bullseye-slim
LABEL AUTHOR yusiwen@gmail.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y tzdata vim tmux git clang libreadline-dev cmake \
    libssl-dev make gcc g++ libboost-all-dev libace-dev wget lsb-release gnupg libbz2-dev && \
    echo 'deb http://repo.mysql.com/apt/ubuntu bionic mysql-5.7' > /etc/apt/sources.list.d/mysql.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29 && \
    apt-get update && apt-get install -y mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7* libmysqlclient20 libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

COPY entry.sh /
RUN chmod 755 /entry.sh
ENTRYPOINT ["/entry.sh"]
