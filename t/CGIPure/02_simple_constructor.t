# $Id: 02_simple_constructor.t,v 1.2 2004-09-28 17:15:33 skim Exp $

print "Testing: new() plain constructor.\n" if $debug;
$obj = new $class();
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);

print "Testing: new() empty constructor.\n" if $debug;
$obj = new $class('');
ok($obj, qr/$class/);
$obj = new $class({});
ok($obj, qr/$class/);

