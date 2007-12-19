
# a basic uncompressed packet decoding test
# Mon Dec 10 2007, Hessu, OH7LZB

use Test;

BEGIN { plan tests => 15 };
use Ham::APRS::FAP qw(parseaprs);

my $comment = "/RELAY,WIDE, OH2AP Jarvenpaa";
my $phg = "7220";
my $srccall = "OH2RDP-1";
my $dstcall = "BEACON-15";
my $aprspacket = "$srccall>$dstcall,OH2RDG*,WIDE:!6028.51N/02505.68E#PHG$phg$comment";
my %h;
my $retval = parseaprs($aprspacket, \%h);

ok($retval, 1, "failed to parse a basic uncompressed packet (northeast)");
ok($h{'srccallsign'}, $srccall, "incorrect source callsign parsing");
ok($h{'dstcallsign'}, $dstcall, "incorrect destination callsign parsing");
ok(sprintf('%.4f', $h{'latitude'}), "60.4752", "incorrect latitude parsing (northern)");
ok(sprintf('%.4f', $h{'longitude'}), "25.0947", "incorrect longitude parsing (eastern)");
ok($h{'phg'}, $phg, "incorrect PHG parsing");
ok($h{'comment'}, $comment, "incorrect comment parsing");

my @digis = @{ $h{'digipeaters'} };
ok(${ $digis[0] }{'call'}, 'OH2RDG', "Incorrect first digi parsing");
ok(${ $digis[0] }{'wasdigied'}, '1', "Incorrect first digipeated bit parsing");
ok(${ $digis[1] }{'call'}, 'WIDE', "Incorrect second digi parsing");
ok(${ $digis[1] }{'wasdigied'}, '0', "Incorrect second digipeated bit parsing");
ok($#digis, 1, "Incorrect amount of digipeaters parsed");

# and the same, southwestern...
%h = (); # clean up
$aprspacket = "$srccall>$dstcall,OH2RDG*,WIDE:!6028.51S/02505.68W#PHG$phg$comment";
$retval = parseaprs($aprspacket, \%h);

ok($retval, 1, "failed to parse a basic uncompressed packet (southwest)");
ok(sprintf('%.4f', $h{'latitude'}), "-60.4752", "incorrect latitude parsing (southern)");
ok(sprintf('%.4f', $h{'longitude'}), "-25.0947", "incorrect longitude parsing (western)");

