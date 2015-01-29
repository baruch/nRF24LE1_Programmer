package common;

sub find_port {
  my @port_globs = ('/dev/ttyACM*', '/dev/ttyUSB*', '/dev/tty.usbserial*', '/dev/tty.usbmodem*');
  for my $port_glob (@port_globs) {
          my @ports = glob($port_glob);
          return @ports[0] if (@ports);
  }

  return '';
}

sub setup_port {
  my $port = shift;
  system("stty -F $port cs8 115200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts");
  open(my $SERIAL, "+<", $port) or die "Cannot open $port: $!";
  return $SERIAL;
}

sub dump_only {
  my $port = shift;
  my $trigger = shift;

  my $SERIAL = setup_port($port);

  #Send the read infopage trigger character
  print $SERIAL $trigger;

  while (1) {

    while (!defined($_ = <$SERIAL>)) {}

    print;
    chomp;

    last if /DONE/;
  }

  close($SERIAL);
}

@EXPORT = qw(setup_port find_port dump_only);
1;
