#!/usr/bin/awk -f

## usage: set_cols(array)
##   sets the following values in "array" with tput. printing them will format
##   any text afterwards. colors and formats are:
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
function set_cols(array) {
  # bold
  cmd = "tput bold";
  cmd | getline array["bold"];
  close(cmd);
  # black
  cmd = "tput setaf 0";
  cmd | getline array["black"];
  close(cmd);
  # red
  cmd = "tput setaf 1";
  cmd | getline array["red"];
  close(cmd);
  # green
  cmd = "tput setaf 2";
  cmd | getline array["green"];
  close(cmd);
  # yellow
  cmd = "tput setaf 3";
  cmd | getline array["yellow"];
  close(cmd);
  # blue
  cmd = "tput setaf 4";
  cmd | getline array["blue"];
  close(cmd);
  # magenta
  cmd = "tput setaf 5";
  cmd | getline array["magenta"];
  close(cmd);
  # cyan
  cmd = "tput setaf 6";
  cmd | getline array["cyan"];
  close(cmd);
  # white
  cmd = "tput setaf 7";
  cmd | getline array["white"];
  close(cmd);
  # reset
  cmd = "tput sgr0";
  cmd | getline array["reset"];
  close(cmd);
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
