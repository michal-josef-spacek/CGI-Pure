# Modules.
use CGI::Pure;
use Test::More 'tests' => 18;

print "Testing: param() empty method.\n";
my $obj = CGI::Pure->new;
my $param = $obj->param;
is($param, 0);
my @params = $obj->param;
is($#params, -1);

print "Testing: param('param') not inicialized param.\n";
$obj = CGI::Pure->new;
$param = $obj->param('param');
is($param, undef);
@params = $obj->param;
is($#params, -1);

print "Testing: param('param', 'value') is initialization of 'param' value.\n";
$obj = CGI::Pure->new;
$param = $obj->param('param', 'value');
is($param, 'value');
@params = $obj->param('param', 'value');
is(join(' ', @params), 'value');

print "Testing: param('param', ['value1', 'value2']) is initialization of ".
	"'param' value.\n";
$obj = CGI::Pure->new;
$param = $obj->param('param', ['value1', 'value2']);
is($param, 'value1');
@params = $obj->param('param', ['value1', 'value2']);
is(join(' ', @params), 'value1 value2');

print "Testing: param('param', 'value3') is overwriting of 'param' value.\n";
$param = $obj->param('param', 'value3');
is($param, 'value3');
@params = $obj->param('param', 'value3');
is(join(' ', @params), 'value3');

print "Testing: param('param') read 'param' value.\n";
$param = $obj->param('param');
is($param, 'value3');
@params = $obj->param('param');
is(join(' ', @params), 'value3');

print "Testing: append_param('param', 'value4') adding 'value4' of param ".
	"'param'.\n";
$param = $obj->append_param('param', 'value4');
is($param, 'value3');
@params = $obj->param('param');
is(join(' ', @params), 'value3 value4');

print "Testing: delete_param('param') deletes param 'param'.\n";
my $ret = $obj->delete_param('param');
is($ret, 1);
$param = $obj->param('param');
is($param, undef);
@params = $obj->param('param');
is($#params, -1);

print "Testing: delete_param('param') deletes no-exists param 'param'.\n";
$ret = $obj->delete_param('param');
is($ret, undef);
