# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure;
use Test::More 'tests' => 18;

# Test.
my $obj = CGI::Pure->new;
my $param = $obj->param;
is($param, undef);
my @params = $obj->param;
is(@params, 0);

# Test.
$obj = CGI::Pure->new;
$param = $obj->param('param');
is($param, undef);
@params = $obj->param;
is(@params, 0);

# Test.
$obj = CGI::Pure->new;
$param = $obj->param('param', 'value');
is($param, 'value');
@params = $obj->param('param', 'value');
is_deeply(
	\@params,
	[
		'value',
	],
);

# Test.
$obj = CGI::Pure->new;
$param = $obj->param('param', ['value1', 'value2']);
is($param, 'value1');
@params = $obj->param('param', ['value1', 'value2']);
is_deeply(
	\@params,
	[
		'value1',
		'value2',
	],
);

# Test.
$param = $obj->param('param', 'value3');
is($param, 'value3');
@params = $obj->param('param', 'value3');
is_deeply(
	\@params,
	[
		'value3',
	],
);

# Test.
$param = $obj->param('param');
is($param, 'value3');
@params = $obj->param('param');
is_deeply(
	\@params,
	[
		'value3',
	],
);

# Test.
$param = $obj->append_param('param', 'value4');
is($param, 'value3');
@params = $obj->param('param');
is_deeply(
	\@params,
	[
		'value3',
		'value4',
	],
);

# Test.
my $ret = $obj->delete_param('param');
is($ret, 1);
$param = $obj->param('param');
is($param, undef);
@params = $obj->param('param');
is(@params, 0);

# Test.
$ret = $obj->delete_param('param');
is($ret, undef);
