# new() plain constructor
print "Testing: new() plain constructor.\n" if $debug;
$q = new SCGI();
ok(defined $q, 1);
ok($q->isa('SCGI'), 1);
ok($q, qr/SCGI/);

# new('') empty constructor
print "Testing: new() empty constructor.\n" if $debug;
$q = new SCGI('');
ok($q, qr/SCGI/);
$q = new SCGI({});
ok($q, qr/SCGI/);
