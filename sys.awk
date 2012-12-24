#!/usr/bin/awk -f

## usage: isatty(fd)
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

## usage: mktemp(template [, type])
## creates a temporary file or directory, safely, and returns its name.
## if template is not a pathname, the file will be created in ENVIRON["TMPDIR"]
## if set, otherwise /tmp. the last six characters of template must be "XXXXXX",
## and these are replaced with a string that makes the filename unique. type, if
## supplied, is either "f", "d", or "u": for file, directory, or dry run (just
## returns the name, doesn't create a file), respectively. If template is not
## provided, uses "tmp.XXXXXX". Files are created u+rw, and directories u+rwx,
## minus umask restrictions. returns -1 if an error occurs.
function mktemp(template, type,
                c, chars, len, dir, dir_esc, rstring, i, out, out_esc, umask,
                cmd) {
  # portable filename characters
  c = "012345689ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  len = split(c, chars, "");

  # make sure template is valid
  if (length(template)) {
    if (template !~ /XXXXXX$/) {
      return -1;
    }

  # template was not supplied, use the default
  } else {
    template = "tmp.XXXXXX";
  }

  # make sure type is valid
  if (length(type)) {
    if (type !~ /^[fdu]$/) {
      return -1;
    }

  # type was not supplied, use the default
  } else {
    type = "f";
  }

  # if template is a path...
  if (template ~ /\//) {
    dir = template;
    sub(/\/[^/]*$/, "", dir);
    sub(/.*\//, "", template);

  # template is not a path, determine base dir
  } else {
    if (length(ENVIRON["TMPDIR"])) {
      dir = ENVIRON["TMPDIR"];
    } else {
      dir = "/tmp";
    }
  }

  # escape dir for shell commands
  esc_dir = dir;
  sub(/'/, "'\\''", esc_dir);
  esc_dir = "'" esc_dir "'";

  # if this is not a dry run, make sure the dir exists
  if (type != "u" && system("test -d " esc_dir)) {
    return -1;
  }

  # get the base of the template, sans Xs
  template = substr(template, 0, length(template) - 6);
  
  # generate the filename
  do {
    rstring = "";
    for (i=0; i<6; i++) {
      c = chars[int(rand() * len) + 1];
      rstring = rstring c;
    }
    
    out_esc = out = dir "/" template rstring;
    sub(/'/, "'\\''", out_esc);
    out_esc = "'" out_esc "'";
  } while (!system("test -e " out_esc));

  # if needed, create the filename
  if (type == "f") {
    system("touch " out_esc);
    cmd = "umask";
    cmd | getline umask;
    close(cmd);
    umask = substr(umask, 2, 1);
    system("chmod 0" 6 - umask "00 " out_esc);
  } else if (type == "d") {
    system("mkdir " out_esc);
    cmd = "umask";
    cmd | getline umask;
    close(cmd);
    umask = substr(umask, 2, 1);
    system("chmod 0" 7 - umask "00 " out_esc);
  }

  # return the filename
  return out;
}



# Copyright Daniel Mills <dm@e36freak.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
