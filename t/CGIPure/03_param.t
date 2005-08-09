# $Id: 03_param.t,v 1.3 2005-08-09 08:32:23 skim Exp $

print "Testing: param() empty method.\n" if $debug;
my $obj = $class->new;
my $param = $obj->param;
ok($param, 0);
my @params = $obj->param;
ok($#params, -1);

print "Testing: param('param') not inicialized param.\n" if $debug;
$obj = $class->new;
$param = $obj->param('param');
ok($param, undef);
@params = $obj->param;
ok($#params, -1);

print "Testing: param('param', 'value') is inicialization of 'param' value.\n"
	if $debug;
$obj = $class->new;
$param = $obj->param('param', 'value');
ok($param, 'value');
@params = $obj->param('param', 'value');
ok(join(' ', @params), 'value');

print "Testing: param('param', ['value1', 'value2']) is inicialization of ".
	"'param' value.\n" if $debug;
$obj = $class->new;
$param = $obj->param('param', ['value1', 'value2']);
ok($param, 'value1');
@params = $obj->param('param', ['value1', 'value2']);
ok(join(' ', @params), 'value1 value2');

print "Testing: param('param', 'value3') is overwriting of 'param' value.\n" 
	if $debug;
$param = $obj->param('param', 'value3');
ok($param, 'value3');
@params = $obj->param('param', 'value3');
ok(join(' ', @params), 'value3');

print "Testing: param('param') read 'param' value.\n" if $debug;
$param = $obj->param('param');
ok($param, 'value3');
@params = $obj->param('param');
ok(join(' ', @params), 'value3');

print "Testing: append_param('param', 'value4') adding 'value4' of param ".
	"'param'.\n" if $debug;
$param = $obj->append_param('param', 'value4');
ok($param, 'value3');
@params = $obj->param('param');
ok(join(' ', @params), 'value3 value4');

print "Testing: delete_param('param') deletes param 'param'.\n";
my $ret = $obj->delete_param('param');
ok($ret, 1);
$param = $obj->param('param');
ok($param, undef);
@params = $obj->param('param');
ok($#params, -1);

print "Testing: delete_param('param') deletes no-exists param 'param'.\n";
$ret = $obj->delete_param('param');
ok($ret, undef);

