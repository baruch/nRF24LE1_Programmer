#!/usr/bin/perl

# Serial.pl - Use the programmer as a serial console

#  Copyright (c) 2014 Dean Cording
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

use strict;
use warnings;

use common;

# Make STDOUT auto-flushing when output is piped
my $old_fh = select(STDOUT);
$| = 1;
select($old_fh);

my $port = common::find_port();
if (@ARGV != 1 && !$port) {
  print "Usage: $0 <Arduino Serial Port>\n";
  exit;
}

# Serial port settings to suit Arduino
print "Using port $port\n";

local *SERIAL = common::setup_port($port);

#Send the serial monitor trigger character
print SERIAL "s";

while (1) {

  while (!defined($_ = <SERIAL>)) {}

  print;
  chomp;

  last if /DONE/;
}

# Terminate the serial session
print SERIAL "\x01";

close(SERIAL);
