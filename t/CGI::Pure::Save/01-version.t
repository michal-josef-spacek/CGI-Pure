# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure::Save;
use Test::More 'tests' => 1;

# Test.
is($CGI::Pure::Save::VERSION, 0.01, 'Version.');
