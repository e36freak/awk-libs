#!/usr/bin/awk -f

## usage: center(string[, width])
## returns "string" centered based on "width". if "width" is not provided (or 
## is 0), uses the width of the terminal, or 80 if standard output is not open
## on a terminal.
## note: does not check the length of the string. if it's wider than the
## terminal, it will not center lines other than the first. for best results,
## combine with fold() (see the cfold script in the examples directory for a
## script that does exactly this)
function center(str, cols,    off, cmd) {
  if (!cols) {
    # checks if stdout is a tty
    if (system("test -t 1")) {
      cols = 80;
    } else {
      cmd = "tput cols";
      cmd | getline cols;
      close(cmd);
    }
  }

  off = int((cols/2) + (length(str)/2));

  return sprintf("%*s", off, str);
}

## usage: delete_arr(array)
## deletes every element in "array"
function delete_arr(arr) {
  split("", arr);
}

## usage: fold(string, sep[, width])
## returns "string", wrapped, with lines broken on "sep" to "width" columns.
## "sep" is a list of characters to break at, similar to IFS in a POSIX shell.
## if "sep" is empty, wraps at exactly "width" characters. if "width" is not
## provided (or is 0), uses the width of the terminal, or 80 if standard output
## is not open on a terminal.
## note: currently, tabs are squeezed to a single space. this will be fixed
function fold(str, sep, cols,    out, cmd, i, len, chars, c, last, f, first) {
  if (!cols) {
    # checks if stdout is a tty
    if (system("test -t 1")) {
      cols = 80;
    } else {
      cmd = "tput cols";
      cmd | getline cols;
      close(cmd);
    }
  }

  # squeeze tabs and newlines to spaces
  gsub(/[\t\n]/, " ", str);

  # if "sep" is empty, just fold on cols with substr
  if (!length(sep)) {
    len = length(str);

    out = substr(str, 1, cols);
    for (i=cols+1; i<=len; i+=cols) {
      out = out "\n" substr(str, i, cols);
    }

    return out;

  # otherwise, we have to loop over every character (can't split() on sep, it
  # would destroy the existing separators)
  } else {
    # split string into char array
    len = split(str, chars, //);
    # set boolean, used to assign the first line differently
    first = 1;

    for (i=1; i<=len; i+=last) {
      f = 0;
      for (c=i+cols-1; c>=i; c--) {
        if (index(sep, chars[c])) {
          last = c - i + 1;
          f = 1;
          break;
        }
      }

      if (!f) {
        last = cols;
      }

      if (first) {
        out = substr(str, i, last);
        first = 0;
      } else {
        out = out "\n" substr(str, i, last);
      }
    }
  }

  # return the output
  return out;
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

## usage: shell_esc(string)
## returns the string escaped so that it can be used in a shell command
function shell_esc(str) {
  gsub(/'/, "'\\''", str);

  return "'" str "'";
}

## usage: str_to_arr(string, array)
## converts string to an array, one char per element, 1-indexed
## returns the array length
function str_to_arr(str, arr) {
  return split(str, arr, //);
}

## usage: fwidths(width_spec [, string]) **
## extracts substrings from "string" according to "width_spec" from left to
## right and assigns them to $1, $2, etc. also assigns the NF variable. if
## "string" is not supplied, uses $0. "width_spec" is a space separated list of
## numbers that specify field widths, just like GNU awk's FIELDWIDTHS variable.
## returns the value for NF.
function fwidths(wspec, str,    fw, i, len) {
  if (!length(str)) {
    str = $0;
  }

  # turn wspec into the array fw
  len = split(wspec, fw, / /);
  
  # loop over each wspec value, while the string is not exhausted
  for (i=1; str != "" && i <= len; i++) {
    # assign the field
    $i = substr(str, 1, fw[i]);

    # chop the value off of the original string
    str = substr(str, fw[i] + 1);
  }

  # set and return NF
  NF = i - 1;
  return NF;
}

## usage: fwidths_arr(width_spec, array [, string]) **
## the behavior is the same as that of fwidths(), except that the values are
## assigned to "array", indexed with sequential integers starting with 1.
## returns the length. everything else is described in fwidths() above.
function fwidths_arr(wspec, arr, str,    fw, i, len) {
  if (!length(str)) {
    str = $0;
  }

  # turn wspec into the array fw
  len = split(wspec, fw, / /);

  # loop over each wspec value, while the string is not exhausted
  for (i=1; str != "" && i <= len; i++) {
    # assign the array element
    arr[i] = substr(str, 1, fw[i]);

    # chop the value off of the original string
    str = substr(str, fw[i] + 1);
  }

  # return the array length
  return i - 1;
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
