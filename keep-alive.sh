#!/bin/bash
while true; do
  curl -s http://localhost:11434/api/tags > /dev/null
  echo "Ping at $(date)" >> ~/ping.log
  sleep 60
done