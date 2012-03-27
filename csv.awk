#!/bin/awk -f

## usage: create_line(array, max [, sep [, qualifier] ])
## Generates an output line in quoted CSV format, from the contents of "array"
## "array" is expected to be an indexed array (1-indexed). "max" is the highest
## index to be used. "sep", if provided, is the field separator. If it is more
## than one character, the first character in the string is used. By default,
## it is a comma. "qualifier", if provided, is the quote character. Like "sep",
## it is one character. The default value is `"'. For example, the array:
## a[1]="foo"; a[2]="bar,quux"; a[3]="blah\"baz", when called with
## create_line(a, 3), will return: "foo","bar,quux","blah""baz". Returns -1 if
## an error occurs.
## note: expects a non-sparse array. empty or unset values will become
## empty fields
function create_line(arr, len, sep, q,    i, out, c, new) {
  # set "sep" if the arg was provided, using the first char
  if (length(sep)) {
    sep = substr(sep, 1, 1);
  # default
  } else {
    sep = ",";
  }

  # set "q" if the arg was provided, using the first char
  if (length(q)) {
    q = substr(q, 1, 1);
  # default
  } else {
    q = "\"";
  }

  # empty the output string
  out = "";

  # iterate over the array elements
  for (i=1; i<=len; i++) {
    # empty escaped string
    new = "";
    # create escaped string
    while (c = index(arr[i], q)) {
      new = new substr(arr[i], 1, c - 1) q q;
      arr[i] = substr(arr[i], c + 1);
    }
    new = new arr[i];

    # quote escaped string, add to output with sep
    out = (i > 1) ? out sep q new q : q new q;
  }

  # return output string
  return out;
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
      # if the next char is a quote, and the previous character is not a
      # delimiter, it's an escaped literal quote (allows empty fields 
      # that are quoted, such as "foo","","bar")
      if (a[c+1] == q && a[c-1] != sep) {
        arr[cur] = arr[cur] a[c];
        c++;

      # otherwise, it's a qualifier. switch boolean
      } else {
        isin = ! isin;
      }

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
