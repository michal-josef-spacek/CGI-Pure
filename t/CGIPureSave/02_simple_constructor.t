# $Id: 02_simple_constructor.t,v 1.1 2004-09-28 21:02:39 skim Exp $

print "Testing: new() plain constructor.\n" if $debug;
eval {
	$obj = new $class();
};
$@ =~ s/(.*)\ at.*\n/$1/;
ok($@, "$class: SCGI object doesn't define.");

print "Testing: new('scgi' => 'SCGI_object') constructor.\n" if $debug;
use SCGI;
my $scgi = new SCGI();
$obj = new $class('scgi' => $scgi);
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);
