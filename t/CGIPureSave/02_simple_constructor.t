# $Id: 02_simple_constructor.t,v 1.2 2005-01-07 21:51:25 skim Exp $

print "Testing: new() plain constructor.\n" if $debug;
eval {
	$obj = new $class();
};
$@ =~ s/(.*)\ at.*\n/$1/;
ok($@, "$class: CGI::Pure object doesn't define.");

print "Testing: new('cgi_pure' => 'CGI::Pure object') constructor.\n" if $debug;
use CGI::Pure;
my $cgi_pure = new CGI::Pure();
$obj = new $class('cgi_pure' => $cgi_pure);
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);
