# Modules.
use CGI::Pure;
use Test::More 'tests' => 2;

# Debug message.
print "Testing: append_param() method.\n";

# Test.
my $obj = CGI::Pure->new;
my @ret = $obj->append_param('param', 'foo');
is_deeply(
	\@ret,
	[
		'foo',
	],
);

# Test.
@ret = $obj->append_param('param', 'bar');
is_deeply(
	\@ret,
	[
		'bar',
		'foo',
	],
);