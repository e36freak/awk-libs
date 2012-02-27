#!/bin/awk -f

## usage: shell_escape(string)
## returns the string escaped so that it can be used in a shell command
function shell_escape(str) {
  gsub(/'/, "'\\''", str);

  return "'" str "'";
}

## usage: str_to_arr(string, array)
## converts string to an array, one char per element, 1-indexed
## returns the array length
function str_to_arr(str, arr,    len, i) {
  delete arr;
  len = length(str);

  for (i=1; i<=len; i++) {
    arr[i] = substr(str, i, 1);
  }

  return len;
}

## usage: qsplit(string, array [, sep [, quantifier] ])
## a version of split() designed for CSV-like data. splits "string" on "sep"
## (,) if not provided, into array[1], array[2], ... array[n]. returns "n".
## both "sep" and "quantifier" will use the first character in the provided
## string. uses "quantifier" (" if not provided) and ignores "sep" within
## quoted fields. for example, foo,"bar,baz",blah will be split as such:
## array[1] = "foo"; array[2] = "bar,baz"; array[3] = "blah";
## currently, mid-field quantifiers are ignored
## TODO: properly handle quotes mid-field, consider allowing an ERE for "sep"
function qsplit(str, arr, sep, q,    i, c, l, tarr) {
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

  # split the string into the temporary array "tarr" on "sep"
  l = split(str, tarr, sep);

  # "c" contains the current element of 'arr' the function is assigning to
  c = 1;
  # iterate over each element of "tarr"
  i = 1;
  while (i <= l) {
    # if the element starts with "q"...
    if (substr(tarr[i], 1, 1) == q) {
      # loop over each element, starting with the current one, concatenating
      # and appending to "arr" until an element ends with "q"
      do {
        arr[c] = (c in arr) ? arr[c] sep tarr[i] : tarr[i];
      } while ((foo = substr(tarr[i], length(tarr[i++]))) != q && i <= l);

    # otherwise, just append the current field to "arr"
    } else {
      arr[c] = tarr[i++];
    }

    c++;
  }

  # return the length
  return c - 1;
}
