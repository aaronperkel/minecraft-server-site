#!/bin/bash
# backup_server.sh
# Saves and backs up the entire ~/server folder without overwriting existing backups.

# Function to send commands to the Minecraft server
server_command() {
    screen -S minecraftserver -p 0 -X stuff "$1$(printf \\r)"
}

# Commands to save the server and notify players
SAVE_COMMAND="save-all flush"
START_MESSAGE="say Starting server backup..."
END_MESSAGE="say Finished server backup."

# Create a timestamp for the backup filename (e.g., 20250123-0352)
TIMESTAMP=$(date +%Y%m%d-%H%M)

# Backup directory
BACKUP_DIR=~/backups

# Perform the backup
server_command "$START_MESSAGE"
server_command "$SAVE_COMMAND"
sleep 5

# Create a unique backup directory with the timestamp
cp -r /srv/minecraft "${BACKUP_DIR}/server_backup_${TIMESTAMP}"

server_command "$END_MESSAGE"
