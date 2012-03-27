#!/bin/awk -f

## usage: ssub(ere, repl[, in])
## behave like sub, except returns the result and doesn't modify the original
function ssub(ere, repl, str) {
  if (!length(str)) {
    str = $0;
  }

  sub(ere, repl, str);
  return str;
}

## usage: sgsub(ere, repl[, in])
## behave like gsub, except returns the result and doesn't modify the original
function sgsub(ere, repl, str) {
  if (!length(str)) {
    str = $0;
  }

  gsub(ere, repl, str);
  return str;
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
  len = split(str, a, //);

  for (i=len; i>0; i--) {
    o = o a[i];
  }

  return o;
}
