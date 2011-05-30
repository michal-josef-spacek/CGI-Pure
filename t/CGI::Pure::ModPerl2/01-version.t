# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure::ModPerl2;
use Test::More 'tests' => 1;

# Test.
is($CGI::Pure::ModPerl2::VERSION, 0.01, 'Version.');
