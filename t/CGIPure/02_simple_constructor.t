# $Id: 02_simple_constructor.t,v 1.4 2006-02-08 21:30:15 skim Exp $

print "Testing: new() plain constructor.\n" if $debug;
my $obj = $class->new;
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);

print "Testing: new() empty constructor.\n" if $debug;
eval {
	$obj = $class->new('');
};
ok($@, "Unknown parameter ''.\n");
