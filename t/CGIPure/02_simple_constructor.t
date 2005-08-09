# $Id: 02_simple_constructor.t,v 1.3 2005-08-09 08:32:23 skim Exp $

print "Testing: new() plain constructor.\n" if $debug;
my $obj = $class->new;
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);

print "Testing: new() empty constructor.\n" if $debug;
$obj = $class->new('');
ok($obj, qr/$class/);
$obj = $class->new({});
ok($obj, qr/$class/);

