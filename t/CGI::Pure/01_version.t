# Modules.
use CGI::Pure;
use Test::More 'tests' => 1;

print "Testing: version.\n";
is($CGI::Pure::VERSION, '0.03');
