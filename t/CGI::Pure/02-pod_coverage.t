# Modules.
use Test::Pod::Coverage 'tests' => 1;

# Debug message.
print "Testing: Pod coverage.\n";

# Test.
pod_coverage_ok('CGI::Pure', 'CGI::Pure is covered.');
