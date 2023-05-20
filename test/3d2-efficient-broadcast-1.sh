#!/bin/bash
set -e
scripts/build.sh
/tmp/maelstrom/maelstrom test -w broadcast --bin /tmp/node-server.exe --node-count 25 --time-limit 20 --rate 100 --latency 100 --nemesis partition --log-stderr
