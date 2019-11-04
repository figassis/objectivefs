FROM ubuntu:latest
LABEL maintainer="Assis Ngolo <figassis@gmail.com>"

WORKDIR /tmp

#ENV OS_LOCALE=en_US.UTF-8 LANG=${OS_LOCALE} LANGUAGE=${OS_LOCALE} LC_ALL=${OS_LOCALE} DEBIAN_FRONTEND=noninteractive

ENV BUCKET=mybucket.domain.com
ENV ACCOUNT=user@objectivefs.com

ENV OBJECTIVEFS_LICENSE="20%"

#The filesystem passphrase is required to mount your filesystem
ENV OBJECTIVEFS_PASSPHRASE="20%"

ENV AWS_ACCESS_KEY_ID=myawskeyid
ENV AWS_SECRET_ACCESS_KEY=myawssecretkey
ENV AWS_DEFAULT_REGION=us-east-1
#ENV AWS_TRANSFER_ACCELERATION=0

#Set cache size as a percentage of memory (e.g. 30%) or an absolute value (e.g. 500M or 1G). (Default: 20%)
ENV CACHESIZE="20%"

#<DISK CACHE SIZE>[:<FREE SPACE>]
ENV DISKCACHE_SIZE="200G:200G"
ENV DISKCACHE_PATH=/var/cache/objectivefs
ENV MOUNT_PATH=/volume


RUN apt-get update -y && apt-get -y install --no-install-recommends -y locales curl wget vim git unzip \
    fuse ca-certificates unzip psmisc software-properties-common supervisor ntpdate && \
    locale-gen ${OS_LOCALE} && dpkg-reconfigure locales && \
    apt-get purge -y --auto-remove $BUILD_DEPS && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://s3.amazonaws.com/files.nellcorp.com/assets/ofs/objectivefs_6.4_amd64.deb && dpkg -i objectivefs_6.4_amd64.deb

WORKDIR /
ADD entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint && mkdir ${MOUNT_PATH} /pids

VOLUME ${MOUNT_PATH}
VOLUME ${DISKCACHE_PATH}

ENTRYPOINT ["/bin/entrypoint"]