#!/bin/bash
set -e
scripts/build.sh
/tmp/maelstrom/maelstrom test -w echo --bin /tmp/node-server.exe --node-count 1 --time-limit 10 --log-stderr
