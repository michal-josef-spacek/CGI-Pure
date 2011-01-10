# Modules.
use CGI::Pure::ModPerl2;
use Test::More 'tests' => 1;

print "Testing: version.\n";
is($CGI::Pure::ModPerl2::VERSION, '0.01');
