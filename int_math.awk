#!/bin/awk -f

## usage: ceil(multiple, number)
## returns "number" rounded UP to the nearest multiple of "multiple"
function ceil(mult, num,    r) {
  return (r = num % mult) ? num + (mult - r) : num;
}

## usage: change_base(number, start_base, end_base)
## converts "number" from "start_base" to "end_base"
## bases must be between 2 and 16
## returns 0 if any argument is invalid
function change_base(num, ibase, obase,
                     chars, c, l, i, j, cur, b10, f, fin, isneg) {
  # convert number to lowercase
  num = tolower(num);

  # determine if number is negative. if so, set isneg=1 and remove the '-'
  if (sub(/^-/, "", num)) {
    isneg = 1;
  }

  # determine if inputs are valid
  if (num ~ /[^[:xdigit:]]/ || ibase != int(ibase) || obase != int(obase) ||
      ibase < 2 || ibase > 16 || obase < 2 || obase > 16) {
    return 0;
  }

  # set letters to numbers conversion array
  if (ibase > 10 || obase > 10) {
    # set chars[] array to convert letters to numbers
    chars["a"] = 10; chars["b"] = 11; chars["c"] = 12;
    chars["d"] = 13; chars["e"] = 14; chars["f"] = 15;

    # set chars[] to go the opposite way, as well
    for (c in chars) {
      chars[chars[c]] = c;
    }
  }
  
  # convert to base 10
  if (ibase != 10) { 
    l = length(num);

    j = b10 = 0;
    for (i=l; i>0; i--) {
      c = substr(num, i, 1);

      # if char is a-f convert to dec
      if (c !~ /^[0-9]$/) {
        c = chars[c];
      }

      # check to make sure value isn't too great for base
      if (c >= ibase) {
        return 0;
      }

      b10 += c * (ibase ** j++);
    }
  } else {
    # num is already base 10
    b10 = num;
  }
  
  # convert from base 10 to obase
  if (obase != 10) {
    # build number backwards
    j = 0;
    do {
      f[++j] = (c = b10 % obase) > 9 ? chars[c] : c;
      b10 = int(b10 / obase);
    } while (b10);

    # reverse number
    fin = f[j];
    for (i=j-1; i>0; i--) {
      fin = fin f[i];
    }
  } else {
    # num has already been converted to base 10
    fin = b10;
  }

  # add '-' if number was negative
  if (isneg) {
    fin = "-" fin;
  }

  return fin;
}

## usage: floor(multiple, number)
## returns "number" rounded DOWN to the nearest multiple of "multiple"
function floor(mult, num) {
  return num - (num % mult);
}

## usage: round(multiple, number)
## returns "number" rounded to the nearest multiple of "multiple"
function round(mult, num,    r) {
  if (num % mult < mult / 2) {
    return num - (num % mult);
  } else {
    return (r = num % mult) ? num + (mult - r) : num;
  }
}
