# $Id: 04_load.t,v 1.1 2004-09-28 21:02:39 skim Exp $

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Save";

print "Testing: load(\$fh) - loading parameters to SCGI object.\n" if $debug;
use SCGI;
my $scgi = new SCGI();
$obj = new $class('scgi' => $scgi);
my $file = "$test_dir/Data/params2";
open(INF, $file) || die "Can't open file '$file'.";
my $ret = $obj->load(\*INF);
ok($ret, 1);
close(INF);
my @params = $scgi->param();
ok(join(' ', @params) eq 'param1 param2' 
	|| join(' ', @params) eq 'param2 param1');
