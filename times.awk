#!/bin/awk -f

## usage: month_to_num(month)
## converts human readable month to the decimal representation
## returns the number, -1 if the month doesn't exist
function month_to_num(mon,    months, m) {
  # populate months[] array
  months["january"] =  1; months["february"] =  2; months["march"]     =  3;
  months["april"]   =  4; months["may"]      =  5; months["june"]      =  6;
  months["july"]    =  7; months["august"]   =  8; months["september"] =  9;
  months["october"] = 10; months["november"] = 11; months["december"]  = 12;

  # also populate abbreviations
  for (m in months) {
    months[substr(m, 1, 3)] = months[m];
  }

  # convert month to lowercase
  mon = tolower(mon);

  # check if month exists
  if (mon in months) {
    return months[mon];
  } else {
    return -1;
  }
}

## usage: day_to_num(day)
## converts human readable day to the decimal representation
## returns the number, -1 if the day doesn't exist
function day_to_num(day,    days, d) {
  # populate days[] array
    days["sunday"]    = 1; days["monday"]   = 2; days["tuesday"] = 3;
    days["wednesday"] = 4; days["thursday"] = 5; days["friday"]  = 6;
    days["saturday"]  = 7;

  # also populate abbreviations
    days["sun"]   = 1; days["mon"] = 2; days["tues"] = 3; days["wed"] = 4;
    days["thurs"] = 5; days["fri"] = 6; days["sat"]  = 7;

  # convert day to lowercase
    day = tolower(day);

  # check if day exists
  if (day in days) {
    return days[day];
  } else {
    return -1;
  }
}

## usage: hr_to_sec(timestamp)
## converts HH:MM:SS or MM:SS to seconds
## returns -1 if invalid format
function hr_to_sec(time,    t, l, i, j) {
  # check for valid format
  if (time !~ /^([0-9]+:[0-9]{2}|[0-9]+):[0-9]{2}$/) {
    return -1;
  }

  # convert
  l = split(time, t, /:/);
  
  j = time = 0;
  for (i=l; i>0; i--) {
    time += t[i] * (60 ** j++);
  }

  return time;
}

## usage: sec_to_hr(seconds)
## converts seconds to HH:MM:SS
function sec_to_hr(sec,    m, s) {
  s = sec % 60;
  sec = int(sec / 60);
  m = sec % 60;
  sec = int(sec / 60);

  return sprintf("%02d:%02d:%02d", sec, m, s);
}
