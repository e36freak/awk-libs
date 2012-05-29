#!/bin/awk -f

## usage: set_cols() **
##   sets the following variables with tput. printing them will format any
##   text afterwards. colors and formats are:
##     bold - bold text (can be combined with a color)
##     black - black text
##     red - red text
##     green - green text
##     yellow - yellow text
##     blue - blue text
##     magenta - magenta text
##     cyan - cyan text
##     white - white text
##     reset - resets to default settings
function set_cols() {
  # bold
  cmd = "tput bold";
  cmd | getline bold;
  close(cmd);
  # black
  cmd = "tput setaf 0";
  cmd | getline black;
  close(cmd);
  # red
  cmd = "tput setaf 1";
  cmd | getline red;
  close(cmd);
  # green
  cmd = "tput setaf 2";
  cmd | getline green;
  close(cmd);
  # yellow
  cmd = "tput setaf 3";
  cmd | getline yellow;
  close(cmd);
  # blue
  cmd = "tput setaf 4";
  cmd | getline blue;
  close(cmd);
  # magenta
  cmd = "tput setaf 5";
  cmd | getline magenta;
  close(cmd);
  # cyan
  cmd = "tput setaf 6";
  cmd | getline cyan;
  close(cmd);
  # white
  cmd = "tput setaf 7";
  cmd | getline white;
  close(cmd);
  # reset
  cmd = "tput sgr0";
  cmd | getline reset;
  close(cmd);
}
