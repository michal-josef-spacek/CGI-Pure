# Pragmas.
use strict;
use warnings;

# Modules.
use Test::Pod::Coverage 'tests' => 1;

# Test.
pod_coverage_ok('CGI::Pure::Save', 'CGI::Pure::Save is covered.');
