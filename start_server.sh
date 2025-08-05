#!/bin/bash
# This script starts the server up and brings it back up
# in the case that it crashes/goes down.
# This script needs to be updated when changing the server to a newer version.

LOG_FILE=/srv/minecraft/scripts/start_server.log
exec > >(tee -a "$LOG_FILE") 2>&1

server_command() {
    screen -S minecraftserver -X stuff "$1"
}

export PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin'

JAVA_HOME='/usr/lib/jvm/jdk-23.0.1'
export PATH="$PATH:$JAVA_HOME/bin"

export SCREENDIR="$HOME/.screen"

START_SERVER="java -Xms6G -Xmx6G -jar server.jar nogui\n"

# Set restart flag to true
sed -i "1s/.*/true/" /srv/minecraft/scripts/restart.txt

# Start a detached screen session named minecraftserver
screen -dmS minecraftserver bash -c 'cd /srv/minecraft && exec bash'

# Wait a moment to ensure the screen session is ready
sleep 2

# Send the start server command
server_command "$START_SERVER"

# Monitor the server
while true 
do
    sleep 1m
    C=$(pgrep -f server.jar | wc -l)
    read -r RESTART < ~/server/scripts/restart.txt
    if [ "$C" == "true" ] && [ "$RESTART" == "true" ]; then
        echo "Server is down or not running. Attempting to restart..."
        server_command "$START_SERVER"
    fi	
done
