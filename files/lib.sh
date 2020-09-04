#!/usr/bin/env bash

loadConfig() {
    echo "Loading config"
    chown -R steam:steam /var/csgo/cfg
    [ ! -d "/opt/steam/counterstrike/csgo/cfg/" ] && mkdir -p /opt/steam/counterstrike/csgo/cfg/
    chown -R steam:steam /opt/steam/counterstrike/csgo/cfg/
    yes | cp -rfa /var/csgo/cfg/. /opt/steam/counterstrike/csgo/cfg/
}

storeConfig() {
    echo "Storing config"
    yes | cp -rfa /opt/steam/counterstrike/csgo/cfg/. /var/csgo/cfg/
    chown -R root:root /var/csgo/cfg
}

shutdown() {
    pkill srcds_linux
    storeConfig
    echo "Container stopped"
    exit 143;
}

term_handler() {
    echo "SIGTERM received"
    shutdown
}

no_ctrlc() {
    let ctrlc_count++
    echo
    if [[ $ctrlc_count == 1 ]]; then
        echo "interrupt received: press once more to confirm interrupt"
    else [[ $ctrlc_count == 2 ]]; 
        echo "interrupt confirmed: exiting..."
        exit
    fi
}

install() {
    [ ! -d "/opt/steam/counterstrike" ] install_needed || update
}

install_needed() {
    echo "Installing CS:GO Dedicated Server"
    /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/steam/counterstrike +app_update 740 validate +quit
    chown -R steam:steam /opt/steam/counterstrike
    ln -s /opt/steam/linux32 /home/steam/.steam/sdk32
    echo "Installation done"
}

update() {
    echo "Updating CS:GO Dedicated Server"
    /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/steam/counterstrike +app_update 740 validate +quit
    echo "Update done"
}