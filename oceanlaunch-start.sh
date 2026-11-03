#!/bin/sh
# The site lives in /data/wordpress: a folder of WordPress's own user in the app's storage. (The storage folder itself
# belongs to the server, and WordPress's first-start copy can't run in a folder it doesn't own.)
set -e
mkdir -p /data/wordpress
cd /data/wordpress
exec docker-entrypoint.sh "$@"
