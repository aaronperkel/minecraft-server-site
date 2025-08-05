#!/bin/bash
# backup_world.sh
# Saves and backs up only the ~/server/world folder, overwriting last week's backup for the same day.

# Function to send commands to the Minecraft server
server_command() {
    screen -S minecraftserver -p 0 -X stuff "$1$(printf \\r)"
}

# Commands to save the world and notify players
SAVE_COMMAND="save-all flush"
START_MESSAGE="say Starting world backup..."
END_MESSAGE="say Finished world backup."

# Get the current day of the week (e.g., Monday)
DAY_OF_WEEK=$(date +%A)

# Define the backup filename based on the day
BACKUP_FILENAME="world_backup_${DAY_OF_WEEK}"

# Backup directory
BACKUP_DIR=~/backups

# Perform the backup
server_command "$START_MESSAGE"
server_command "$SAVE_COMMAND"
sleep 5

# Remove the old backup for the day if it exists
rm -rf "${BACKUP_DIR}/${BACKUP_FILENAME}"

# Copy the world folder to the backup location
cp -r /srv/minecraft/world "${BACKUP_DIR}/${BACKUP_FILENAME}"

server_command "$END_MESSAGE"
