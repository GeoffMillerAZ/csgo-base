FROM ubuntu:latest
COPY ./files/ /
RUN echo starting build
RUN set -x
RUN set -e
RUN . ./lib.sh --source-only
RUN trap no_ctrlc INT
RUN trap term_handler TERM
RUN ctrlc_count=0
RUN chmod +x /*.sh
RUN echo Updating OS
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get dist-upgrade
RUN echo Installing dependencies
RUN apt-get install -y wget lib32gcc1 lib32stdc++6 libc6-i386 unzip net-tools libcurl4 locales libselinux1:i386
RUN echo downloading release of steamcmd
RUN wget -O /tmp/steamcmd_linux.tar.gz http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN echo installing steamcmd
RUN mkdir -p /opt/steam
RUN mkdir -p /var/csgo/cfg
RUN tar -C /opt/steam -xvzf /tmp/steamcmd_linux.tar.gz
RUN useradd -ms /bin/bash steam
RUN mkdir -p /home/steam/.steam
RUN chown -R steam:steam /home/steam
RUN echo cleaning up
RUN rm /tmp/steamcmd_linux.tar.gz
RUN apt-get remove -y unzip wget
RUN locale-gen en_US.UTF-8
RUN echo installing counterstrike
RUN install
ADD ./files/ /tmp
VOLUME ["/var/csgo/cfg"]
