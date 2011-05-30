# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure::Fast;
use Test::More 'tests' => 1;

# Test.
is($CGI::Pure::Fast::VERSION, 0.02, 'Version.');
