#!/bin/awk -f

## usage: center(string)
## returns "string" centered based on terminal width, when stdout is a
## terminal. otherwise, assumes an 80 col width when centering.
function center(str,    cols, tty, off, cmd) {
  # checks if stdout is a tty
  if (system("test -t 1")) {
    cols=80
  } else {
    cmd = "tput cols";
    cmd | getline cols;
    close(cmd);
  }

  off = ((cols/2) + (length(str)/2));
  print cols, off;
  return sprintf("%*s", off, str);
}

## usage: ssub(ere, repl[, in])
## behaves like sub, except returns the result and doesn't modify the original
function ssub(ere, repl, str) {
  # if "in" is not provided, use $0
  if (!length(str)) {
    str = $0;
  }

  # substitute
  sub(ere, repl, str);
  return str;
}

## usage: sgsub(ere, repl[, in])
## behaves like gsub, except returns the result and doesn't modify the original
function sgsub(ere, repl, str) {
  # if "in" is not provided, use $0
  if (!length(str)) {
    str = $0;
  }

  # substitute
  gsub(ere, repl, str);
  return str;
}

## usage: lsub(str, repl [, in])
## substites the string "repl" in place of the first instance of "str" in the
## string "in" and returns the result. does not modify the original string.
## if "in" is not provided, uses $0.
function lsub(str, rep, val,    len, i) {
  # if "in" is not provided, use $0
  if (!length(val)) {
    val = $0;
  }

  # get the length of val, in order to know how much of the string to remove
  if (!(len = length(str))) {
    # if "str" is empty, just prepend "rep" and return
    val = rep val;
    return val;
  }

  # substitute val for rep
  if (i = index(val, str)) {
    val = substr(val, 1, i - 1) rep substr(val, i + len);
  }

  # return the result
  return val;
}

## usage: glsub(str, repl [, in])
## behaves like lsub, except it replaces all occurances of "str"
function glsub(str, rep, val,    out, len, i, a, l) {
  # if "in" is not provided, use $0
  if (!length(val)) {
    val = $0;
  }
  # empty the output string
  out = "";

  # get the length of val, in order to know how much of the string to remove
  if (!(len = length(str))) {
    # if "str" is empty, adds "rep" between every character and returns
    l = split(val, a, //);
    for (i=1; i<=l; i++) {
      out = out rep a[i];
    }

    return out rep;
  }

  # loop while 'val' is in 'str'
  while (i = index(val, str)) {
    # append everything up to the search string, and the replacement, to out
    out = out substr(val, 1, i - 1) rep;
    # remove everything up to and including the first instance of str from val
    val = substr(val, i + len);
  }

  # append whatever is left in val to out and return
  return out val;
}

## usage: shell_escape(string)
## returns the string escaped so that it can be used in a shell command
function shell_escape(str) {
  gsub(/'/, "'\\''", str);

  return "'" str "'";
}

## usage: str_to_arr(string, array)
## converts string to an array, one char per element, 1-indexed
## returns the array length
function str_to_arr(str, arr) {
  return split(str, arr, //);
}

## usage: trim(string)
## returns "string" with leading and trailing whitespace trimmed
function trim(str) {
  gsub(/^[[:blank:]]+|[[:blank:]]+$/, "", str);

  return str;
}

## usage: rev(string)
## returns "string" backwards
function rev(str,    a, len, i, o) {
  # split string into character array
  len = split(str, a, //);

  # iterate backwards and append to the output string
  for (i=len; i>0; i--) {
    o = o a[i];
  }

  return o;
}
