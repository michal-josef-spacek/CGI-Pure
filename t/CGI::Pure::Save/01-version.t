# Modules.
use CGI::Pure::Save;
use Test::More 'tests' => 1;

print "Testing: version.\n";
is($CGI::Pure::Save::VERSION, '0.01');
