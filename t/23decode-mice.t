
# a mic-e decoding test
# Tue Dec 11 2007, Hessu, OH7LZB

use Test;

BEGIN { plan tests => 49 + 8};
use Ham::APRS::FAP qw(parseaprs);

my $srccall = "OH7LZB-13";
my $dstcall = "SX15S6";
my $header = "$srccall>$dstcall,TCPIP*,qAC,FOURTH";
my $body = "'I',l \x1C>/]";
my $aprspacket = "$header:$body";
my %h;
my $retval = parseaprs($aprspacket, \%h);

ok($retval, 1, "failed to parse a non-moving target's mic-e packet");
ok($h{'srccallsign'}, $srccall, "incorrect source callsign parsing");
ok($h{'dstcallsign'}, $dstcall, "incorrect destination callsign parsing");

ok($h{'header'}, $header, "incorrect header parsing");
ok($h{'body'}, $body, "incorrect body parsing");
ok($h{'type'}, 'location', "incorrect packet type parsing");

ok($h{'comment'}, ']', "incorrect comment parsing");

my @digis = @{ $h{'digipeaters'} };
ok(${ $digis[0] }{'call'}, 'TCPIP', "Incorrect first digi parsing");
ok(${ $digis[0] }{'wasdigied'}, '1', "Incorrect first digipeated bit parsing");
ok(${ $digis[1] }{'call'}, 'qAC', "Incorrect second digi parsing");
ok(${ $digis[1] }{'wasdigied'}, '0', "Incorrect second digipeated bit parsing");
ok(${ $digis[2] }{'call'}, 'FOURTH', "Incorrect igate call parsing");
ok(${ $digis[2] }{'wasdigied'}, '0', "Incorrect igate digipeated bit parsing");
ok($#digis, 2, "Incorrect amount of digipeaters parsed");

ok($h{'symboltable'}, '/', "incorrect symboltable parsing");
ok($h{'symbolcode'}, '>', "incorrect symbolcode parsing");

# check for undefined value, when there is no such data in the packet
ok($h{'posambiguity'}, 0, "incorrect posambiguity parsing");
ok($h{'messaging'}, undef, "incorrect messaging bit parsing");

ok(sprintf('%.4f', $h{'latitude'}), "-38.2560", "incorrect latitude parsing");
ok(sprintf('%.4f', $h{'longitude'}), "145.1860", "incorrect longitude parsing");
ok(sprintf('%.2f', $h{'posresolution'}), "18.52", "incorrect position resolution");

# check for undefined value, when there is no such data in the packet
ok($h{'speed'}, 0, "incorrect speed");
ok($h{'course'}, 0, "incorrect course");
ok($h{'altitude'}, undef, "incorrect altitude");

$srccall = "OH7LZB-2";
$dstcall = "TQ4W2V";
$header = "$srccall>$dstcall,WIDE2-1,qAo,OH7LZB";
$body = "`c51!f?>/]\"3x}=";
$aprspacket = "$header:$body";
%h = ();
$retval = parseaprs($aprspacket, \%h);

ok($retval, 1, "failed to parse a moving target's mic-e");
ok($h{'srccallsign'}, $srccall, "incorrect source callsign parsing");
ok($h{'dstcallsign'}, $dstcall, "incorrect destination callsign parsing");

ok($h{'header'}, $header, "incorrect header parsing");
ok($h{'body'}, $body, "incorrect body parsing");
ok($h{'type'}, 'location', "incorrect packet type parsing");

ok($h{'comment'}, ']=', "incorrect comment parsing");

@digis = @{ $h{'digipeaters'} };
ok(${ $digis[0] }{'call'}, 'WIDE2-1', "Incorrect first digi parsing");
ok(${ $digis[0] }{'wasdigied'}, '0', "Incorrect first digipeated bit parsing");
ok(${ $digis[1] }{'call'}, 'qAo', "Incorrect second digi parsing");
ok(${ $digis[1] }{'wasdigied'}, '0', "Incorrect second digipeated bit parsing");
ok(${ $digis[2] }{'call'}, 'OH7LZB', "Incorrect igate call parsing");
ok(${ $digis[2] }{'wasdigied'}, '0', "Incorrect igate digipeated bit parsing");
ok($#digis, 2, "Incorrect amount of digipeaters parsed");

ok($h{'symboltable'}, '/', "incorrect symboltable parsing");
ok($h{'symbolcode'}, '>', "incorrect symbolcode parsing");

# check for undefined value, when there is no such data in the packet
ok($h{'posambiguity'}, 0, "incorrect posambiguity parsing");
ok($h{'messaging'}, undef, "incorrect messaging bit parsing");
ok($h{'mbits'}, "110", "incorrect mic-e message type bits");

ok(sprintf('%.4f', $h{'latitude'}), "41.7877", "incorrect latitude parsing");
ok(sprintf('%.4f', $h{'longitude'}), "-71.4202", "incorrect longitude parsing");
ok(sprintf('%.2f', $h{'posresolution'}), "18.52", "incorrect position resolution");

# check for undefined value, when there is no such data in the packet
ok(sprintf("%.2f", $h{'speed'}), "105.56", "incorrect speed");
ok($h{'course'}, "35", "incorrect course");
ok($h{'altitude'}, "6", "incorrect altitude");

#
#### test decoding a packet which has an invalid symbol table (',')
#### configured
#
 
$srccall = "OZ2BRN-4";
$dstcall = "5U2V08";
$header = "$srccall>$dstcall,OZ3RIN-3,OZ4DIA-2*,WIDE2-1,qAR,DB0KUE";
$body = "`'O<l!{,,\"4R}";
$aprspacket = "$header:$body";
%h = ();
$retval = parseaprs($aprspacket, \%h);

ok($retval, 0, "parsed an unparseable mic-e packet");
ok($h{'resultcode'}, 'sym_inv_table', "wrong result code");
ok($h{'srccallsign'}, $srccall, "incorrect source callsign parsing");
ok($h{'dstcallsign'}, $dstcall, "incorrect destination callsign parsing");

ok($h{'header'}, $header, "incorrect header parsing");
ok($h{'body'}, $body, "incorrect body parsing");
ok($h{'type'}, 'location', "incorrect packet type parsing");

ok($h{'comment'}, undef, "incorrect comment parsing");


