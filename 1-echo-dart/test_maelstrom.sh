#!/bin/bash
set -e 
dart compile exe bin/maelstrom_echo.dart -o /tmp/node-server.exe
/tmp/maelstrom/maelstrom test -w echo --bin /tmp/node-server.exe --node-count 1 --time-limit 10
