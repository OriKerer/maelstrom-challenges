#!/bin/bash
set -e
scripts/build.sh
/tmp/maelstrom/maelstrom test -w unique-ids --bin /tmp/node-server.exe --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition --log-stderr
