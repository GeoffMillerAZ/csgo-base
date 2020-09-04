#!/usr/bin/env bash

. ./lib.sh --source-only
ctrlc_count=0

trap term_handler SIGTERM
trap no_ctrlc SIGINT
[ ! -d "/opt/steam/counterstrike" ] && install || update
loadConfig
echo "Starting CS:GO Dedicated Server"
cd /opt/steam/counterstrike
export LD_LIBRARY_PATH=/opt/steam/counterstrike:/opt/steam/counterstrike/bin:${LD_LIBRARY_PATH}
su steam -c "./srcds_linux -game csgo -autoupdate -console -usercon -port $PORT +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $GSLT" & wait ${!}
echo "CS:GO Server died"
shutdown
