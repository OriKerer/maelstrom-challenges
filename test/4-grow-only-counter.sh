#!/bin/bash
set -e
scripts/build.sh
/tmp/maelstrom/maelstrom test -w g-counter --bin /tmp/node-server.exe --node-count 3 --rate 100 --time-limit 20 --nemesis partition --log-stderr
