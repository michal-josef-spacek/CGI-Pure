# Modules.
use CGI::Pure;

print "Testing: new() plain constructor.\n" if $debug;
my $obj;
eval {
	$obj = $class->new;
};
ok($@, "CGI::Pure object doesn't define.\n");

print "Testing: new('cgi_pure' => 'CGI::Pure object') constructor.\n" if $debug;
my $cgi_pure = CGI::Pure->new;
$obj = $class->new('cgi_pure' => $cgi_pure);
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);
