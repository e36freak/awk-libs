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

## usage: qsplit(string, array [, sep [, qualifier] ])
## a version of split() designed for CSV-like data. splits "string" on "sep"
## (,) if not provided, into array[1], array[2], ... array[n]. returns "n".
## both "sep" and "qualifier" will use the first character in the provided
## string. uses "qualifier" (" if not provided) and ignores "sep" within
## quoted fields. doubled qualifiers are considered escaped, and a single 
## qualifier character is used in its place.
## for example, foo,"bar,baz""blah",quux will be split as such:
## array[1] = "foo"; array[2] = "bar,baz\"blah"; array[3] = "quux";
function qsplit(str, arr, sep, q,    a, len, cur, isin, c) {
  delete arr;

  # set "sep" if the argument was provided, using the first char
  if (length(sep)) {
    sep = substr(sep, 1, 1);
  # otherwise, use ","
  } else {
    sep = ",";
  }

  # set "q" if the argument was provided, using the first char
  if (length(q)) {
    q = substr(q, 1, 1);
  # otherwise, use '"'
  } else {
    q = "\"";
  }

  # split the string into the temporary array "a", one element per char
  len = split(str, a, //);

  # "cur" contains the current element of 'arr' the function is assigning to
  cur = 1;
  # boolean, whether or not the iterator is in a quoted string
  isin = 0;
  # iterate over each character
  for (c=1; c<=len; c++) {
    # if the current char is a quote...
    if (a[c] == q) {
      # if the next char is a quote, it's an escaped literal quote. append
      if (a[c+1] == q) {
        arr[cur] = arr[cur] a[c];
        c++;

        continue;
      }

      # otherwise, it's a qualifier. switch boolean.
      isin = ! isin;

    # if the current char is the separator, and we're not within quotes
    } else if (a[c] == sep && !isin) {
      # increment array element
      cur++;

    # otherwise, just append to the current element
    } else {
      arr[cur] = arr[cur] a[c];
    }
  }

  # return length
  return cur;
}
