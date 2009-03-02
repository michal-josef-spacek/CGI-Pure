# Modules.
use CGI::Pure;
use CGI::Pure::Save;
use Test::More 'tests' => 2;

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/CGI::Pure::Save";

print "Testing: load(\$fh) - loading parameters to CGI::Pure object.\n";
my $cgi_pure = CGI::Pure->new;
my $obj = CGI::Pure::Save->new('cgi_pure' => $cgi_pure);
my $file = "$test_dir/data/params2";
open my $inf, $file || die "Can't open file '$file'.";
my $ret = $obj->load($inf);
is($ret, 1);
close $inf;
my @params = $cgi_pure->param;
ok((join q{ }, @params) eq 'param1 param2' 
	|| (join q{ }, @params) eq 'param2 param1');
