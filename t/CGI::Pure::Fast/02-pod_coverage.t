# Modules.
use Test::Pod::Coverage 'tests' => 1;

print "Testing: Pod coverage.\n";
pod_coverage_ok('CGI::Pure::Fast', 'CGI::Pure::Fast is covered.');
