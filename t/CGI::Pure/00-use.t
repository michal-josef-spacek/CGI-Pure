# Modules.
use Test::More 'tests' => 2;

BEGIN {

	# Debug message.
	print "Usage tests.\n";

	# Test.
	use_ok('CGI::Pure');
}

# Test.
require_ok('CGI::Pure');
