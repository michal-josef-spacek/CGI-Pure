# Modules.
use CGI::Pure;
use CGI::Pure::Save;
use Test::More 'tests' => 3;

eval {
	CGI::Pure::Save->new;
};
is($@, "CGI::Pure object doesn't define.\n");

my $cgi_pure = CGI::Pure->new;
my $obj = CGI::Pure::Save->new('cgi_pure' => $cgi_pure);
ok(defined $obj);
ok($obj->isa('CGI::Pure::Save'));
