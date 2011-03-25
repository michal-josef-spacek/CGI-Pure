# Modules.
use CGI::Pure;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($CGI::Pure::VERSION, '0.05');
