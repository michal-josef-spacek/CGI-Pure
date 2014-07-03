# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure;
use Error::Pure::Utils qw(clean);
use English qw(-no_match_vars);
use Test::More 'tests' => 31;
use Test::NoWarnings;

# Test.
my $obj = CGI::Pure->new;
ok(defined $obj);

# Test.
ok($obj->isa('CGI::Pure'));

# Test.
eval {
	CGI::Pure->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");
clean();

# Test.
eval {
	CGI::Pure->new(
		'par_sep' => '+',
	);
};
is($EVAL_ERROR, "Bad parameter separator '+'.\n");
clean();

# Test.
$obj = CGI::Pure->new(
	'par_sep' => ';',
);
ok($obj->isa('CGI::Pure'));

# Test.
$obj = CGI::Pure->new(
	'init' => {'foo' => '1', 'bar' => [2, 3, 4]},
	'utf8' => 1,
);
my @params = $obj->param;
is_deeply(
	\@params,
	[
		'bar',
		'foo',
	],
);
is($obj->param('foo'), 1);
is($obj->param('bar'), 2);
@params = $obj->param('bar');
is_deeply(
	\@params,
	[2, 3, 4],
);

# Test.
$obj = CGI::Pure->new(
	'init' => {'foo' => '1', 'bar' => [2, 3, 4]}, 
	'utf8' => 0
);
@params = $obj->param;
is_deeply(
	\@params,
	[
		'bar',
		'foo',
	],
);
is($obj->param('foo'), 1);
is($obj->param('bar'), 2);
@params = $obj->param('bar');
is_deeply(
	\@params,
	[2, 3, 4],
);

# Test.
$obj = CGI::Pure->new(
	'init' => 'foo=5&bar=6&bar=7&bar=8',
	'utf8' => 1,
);
@params = $obj->param;
is_deeply(
	\@params,
	[
		'bar',
		'foo',
	],
);
is($obj->param('foo'), 5);
is($obj->param('bar'), 6);
@params = $obj->param('bar');
is_deeply(
	\@params,
	[6, 7, 8],
);

# Test.
$obj = CGI::Pure->new(
	'init' => 'foo=5&bar=6&bar=7&bar=8',
	'utf8' => 0,
);
@params = $obj->param;
is_deeply(
	\@params,
	[
		'bar',
		'foo',
	],
);
is($obj->param('foo'), 5);
is($obj->param('bar'), 6);
@params = $obj->param('bar');
is_deeply(
	\@params,
	[6, 7, 8],
);

# Test.
my $old_obj = $obj;
$obj = CGI::Pure->new(
	'init' => $old_obj,
	'utf8' => 1,
);
@params = $obj->param;
is_deeply(
	\@params,
	[
		'bar',
		'foo',
	],
);
is($obj->param('foo'), 5);
is($obj->param('bar'), 6);
@params = $obj->param('bar');
is_deeply(
	\@params,
	[6, 7, 8],
);

# Test.
$obj = CGI::Pure->new(
	'init' => $old_obj,
	'utf8' => 0,
);
@params = $obj->param;
is_deeply(
	\@params,
	[
		'bar',
		'foo',
	],
);
is($obj->param('foo'), 5);
is($obj->param('bar'), 6);
@params = $obj->param('bar');
is_deeply(
	\@params,
	[6, 7, 8],
);

# Test.
$ENV{'QUERY_STRING'} = 'name=JaPh%2C&color=red&color=green&color=blue';
$ENV{'REQUEST_METHOD'} = 'GET';
$obj = CGI::Pure->new;
@params = $obj->param;
is_deeply(
	\@params,
	[
		'color',
		'name',
	],
);
