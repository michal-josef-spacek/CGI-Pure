# $Id: 04_load.t,v 1.2 2005-01-07 21:51:25 skim Exp $

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Save";

print "Testing: load(\$fh) - loading parameters to CGI::Pure object.\n" 
	if $debug;
use CGI::Pure;
my $cgi_pure = new CGI::Pure();
$obj = new $class('cgi_pure' => $cgi_pure);
my $file = "$test_dir/Data/params2";
open(INF, $file) || die "Can't open file '$file'.";
my $ret = $obj->load(\*INF);
ok($ret, 1);
close(INF);
my @params = $cgi_pure->param();
ok(join(' ', @params) eq 'param1 param2' 
	|| join(' ', @params) eq 'param2 param1');
