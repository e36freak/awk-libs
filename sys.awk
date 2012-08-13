#!/usr/bin/awk -f

## usage: isatty(fd) **
## Checks if "fd" is open on a tty. Returns 1 if so, 0 if not, and -1 if an
## error occurs
function isatty(fd) {
  # make sure fd is an int
  if (fd !~ /^[0-9]+$/) {
    return -1;
  }

  # actually test
  return !system("test -t " fd);
}
