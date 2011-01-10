# Modules.
use CGI::Pure::Fast;
use Test::More 'tests' => 1;

print "Testing: version.\n";
is($CGI::Pure::Fast::VERSION, '0.02');
