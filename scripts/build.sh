#!/bin/bash
set -e 
dart pub install
dart run build_runner build
dart compile exe bin/main.dart -o /tmp/node-server.exe
