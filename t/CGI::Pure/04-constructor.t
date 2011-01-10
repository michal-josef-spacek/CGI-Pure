# Modules.
use CGI::Pure;
use English qw(-no_match_vars);
use Test::More 'tests' => 3;

# Debug message.
print "Testing: new() constructor.\n";

# Test.
my $obj = CGI::Pure->new;
ok(defined $obj);

# Test.
ok($obj->isa('CGI::Pure'));

# Test.
eval {
	$obj = CGI::Pure->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");
