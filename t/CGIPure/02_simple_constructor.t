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
