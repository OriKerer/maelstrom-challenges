#!/bin/bash
set -e
scripts/build.sh
/tmp/maelstrom/maelstrom test -w broadcast --bin /tmp/node-server.exe --node-count 5 --time-limit 20 --rate 10 --nemesis partition --log-stderr
