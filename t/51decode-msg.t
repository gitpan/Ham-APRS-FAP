
# message decoding
# Tue Dec 11 2007, Hessu, OH7LZB

use Test;

BEGIN { plan tests => 6 };
use Ham::APRS::FAP qw(parseaprs);

my $srccall = "OH7AA-1";
my $destination = "OH7LZB   ";
my $dstcall = "APRS";
my $messageid = 46;
my $message = "Testing, 1 2 3";
my $aprspacket = "$srccall>$dstcall,WIDE1-1,WIDE2-2,qAo,OH7AA::$destination:$message\{$messageid";
my %h;
my $retval = parseaprs($aprspacket, \%h);

# whitespace will be stripped, ok...
$destination =~ s/\s+$//;

ok($retval, 1, "failed to parse a message packet");
ok($h{'resultcode'}, undef, "wrong result code");
ok($h{'type'}, 'message', "wrong packet type");
ok($h{'destination'}, $destination, "wrong message dst callsign");
ok($h{'messageid'}, $messageid, "wrong message id");
ok($h{'message'}, $message, "wrong message");

