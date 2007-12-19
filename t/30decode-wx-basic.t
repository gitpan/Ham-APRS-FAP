
# a basic wx packet decoding test
# Tue Dec 11 2007, Hessu, OH7LZB

use Test;

BEGIN { plan tests => 27 };
use Ham::APRS::FAP qw(parseaprs);

my $srccall = "OH2RDP-1";
my $dstcall = "BEACON-15";
my $aprspacket = "$srccall>$dstcall,WIDE2-1,qAo,OH2MQK-1:=6030.35N/02443.91E_150/002g004t039r001P002p004h97b10125XRSW";
my %h;
my $retval = parseaprs($aprspacket, \%h);

ok($retval, 1, "failed to parse a basic wx packet");
ok($h{'srccallsign'}, $srccall, "incorrect source callsign parsing");
ok($h{'dstcallsign'}, $dstcall, "incorrect destination callsign parsing");
ok(sprintf('%.4f', $h{'latitude'}), "60.5058", "incorrect latitude parsing (northern)");
ok(sprintf('%.4f', $h{'longitude'}), "24.7318", "incorrect longitude parsing (eastern)");

ok($h{'wx'}->{'wind_direction'}, 150, "incorrect wind direction parsing");
ok($h{'wx'}->{'wind_speed'}, "0.9", "incorrect wind speed parsing");
ok($h{'wx'}->{'wind_gust'}, "1.8", "incorrect wind gust parsing");

ok($h{'wx'}->{'temp'}, "3.9", "incorrect temperature parsing");
ok($h{'wx'}->{'humidity'}, 97, "incorrect humidity parsing");
ok($h{'wx'}->{'pressure'}, "1012.5", "incorrect pressure parsing");

ok($h{'wx'}->{'rain_24h'}, "0.5", "incorrect rain_24h parsing");
ok($h{'wx'}->{'rain_1h'}, "0.3", "incorrect rain_1h parsing");
ok($h{'wx'}->{'rain_midnight'}, "1.0", "incorrect rain_midnight parsing");

ok($h{'wx'}->{'soft'}, "XRSW", "incorrect wx software id");

# another case, with a comment

$aprspacket = "OH2GAX>" . pack('H*', '41505532354E2C54435049502A2C7141432C4F48324741583A403130313331377A363032342E37384E2F30323530332E3937455F3135362F30303167303035743033387230303070303030503030306839316231303039332F74797065203F7361646520666F72206D6F726520777820696E666F');
%h = ();
$retval = parseaprs($aprspacket, \%h);

ok($retval, 1, "failed to parse second basic wx packet");
ok(sprintf('%.4f', $h{'latitude'}), "60.4130", "incorrect latitude parsing (northern)");
ok(sprintf('%.4f', $h{'longitude'}), "25.0662", "incorrect longitude parsing (eastern)");

ok($h{'wx'}->{'wind_direction'}, 156, "incorrect wind direction parsing");
ok($h{'wx'}->{'wind_speed'}, "0.4", "incorrect wind speed parsing");
ok($h{'wx'}->{'wind_gust'}, "2.2", "incorrect wind gust parsing");

ok($h{'wx'}->{'temp'}, "3.3", "incorrect temperature parsing");
ok($h{'wx'}->{'humidity'}, 91, "incorrect humidity parsing");
ok($h{'wx'}->{'pressure'}, "1009.3", "incorrect pressure parsing");

ok($h{'wx'}->{'rain_24h'}, "0.0", "incorrect rain_24h parsing");
ok($h{'wx'}->{'rain_1h'}, "0.0", "incorrect rain_1h parsing");
ok($h{'wx'}->{'rain_midnight'}, "0.0", "incorrect rain_midnight parsing");

