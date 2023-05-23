import 'dart:io';

void log(String toLog) {
  stderr.nonBlocking.writeln('${DateTime.now()}] $toLog');
}
