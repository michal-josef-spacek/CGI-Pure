# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure::ModPerl;
use Test::More 'tests' => 1;

# Test.
is($CGI::Pure::ModPerl::VERSION, 0.01, 'Version.');
