#!/bin/bash
# Sends a command to the running Minecraft server screen.

screen -S minecraftserver -p 0 -X stuff "$1$(printf \\r)"
