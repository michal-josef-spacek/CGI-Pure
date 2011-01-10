# Modules.
use Test::More 'tests' => 2;

BEGIN {
	print "Usage tests.\n";
	use_ok('CGI::Pure::ModPerl2');
}
require_ok('CGI::Pure::ModPerl2');
