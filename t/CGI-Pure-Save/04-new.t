# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure;
use CGI::Pure::Save;
use English qw(-no_match_vars);
use Test::More 'tests' => 2;

# Test.
eval {
	CGI::Pure::Save->new;
};
is($EVAL_ERROR, "CGI::Pure object doesn't define.\n");

# Test.
my $cgi_pure = CGI::Pure->new;
my $obj = CGI::Pure::Save->new('cgi_pure' => $cgi_pure);
isa_ok($obj, 'CGI::Pure::Save');
