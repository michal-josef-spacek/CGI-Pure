# Modules.
use Test::More 'tests' => 2;

BEGIN {
	print "Usage tests.\n";
	use_ok('CGI::Pure::Fast');
}
require_ok('CGI::Pure::Fast');
