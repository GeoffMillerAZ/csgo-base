FROM ubuntu:latest
COPY ./files/ /
RUN echo starting build \
    && . ./lib.sh --source-only \
    && trap no_ctrlc INT \
    && trap term_handler TERM \
    && ctrlc_count=0 \
    && chmod +x /*.sh \
    && echo Updating OS \
    && dpkg --add-architecture i386 \
    && apt-get update && apt-get dist-upgrade \
    && echo Installing dependencies \
    && apt-get install -y wget lib32gcc1 lib32stdc++6 libc6-i386 unzip net-tools libcurl4 locales libselinux1:i386 \
    && echo downloading release of steamcmd \
    && wget -O /tmp/steamcmd_linux.tar.gz http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
    && echo installing steamcmd \
    && mkdir -p /opt/steam \
    && mkdir -p /var/csgo/cfg \
    && tar -C /opt/steam -xvzf /tmp/steamcmd_linux.tar.gz \
    && useradd -ms /bin/bash steam \
    && mkdir -p /home/steam/.steam \
    && chown -R steam:steam /home/steam \
    && echo cleaning up \
    && rm /tmp/steamcmd_linux.tar.gz \
    && apt-get remove -y unzip wget \
    && locale-gen en_US.UTF-8 \
    && echo installing counterstrike \
    && install
ADD ./files/ /tmp
VOLUME ["/var/csgo/cfg"]
