# Modules.
use CGI::Pure;
use CGI::Pure::Save;
use Test::More 'tests' => 3;

print "Testing: new() plain constructor.\n";
my $obj;
eval {
	$obj = CGI::Pure::Save->new;
};
is($@, "CGI::Pure object doesn't define.\n");

print "Testing: new('cgi_pure' => 'CGI::Pure object') constructor.\n";
my $cgi_pure = CGI::Pure->new;
$obj = CGI::Pure::Save->new('cgi_pure' => $cgi_pure);
ok(defined $obj);
ok($obj->isa('CGI::Pure::Save'));
