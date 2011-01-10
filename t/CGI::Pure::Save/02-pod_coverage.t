# Modules.
use Test::Pod::Coverage 'tests' => 1;

print "Testing: Pod coverage.\n";
pod_coverage_ok('CGI::Pure::Save', 'CGI::Pure::Save is covered.');
