# $Id: 04_load.t,v 1.3 2005-08-09 08:32:16 skim Exp $

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Save";

print "Testing: load(\$fh) - loading parameters to CGI::Pure object.\n" 
	if $debug;
use CGI::Pure;
my $cgi_pure = CGI::Pure->new;
my $obj = $class->new('cgi_pure' => $cgi_pure);
my $file = "$test_dir/Data/params2";
open(INF, $file) || die "Can't open file '$file'.";
my $ret = $obj->load(\*INF);
ok($ret, 1);
close(INF);
my @params = $cgi_pure->param;
ok(join(' ', @params) eq 'param1 param2' 
	|| join(' ', @params) eq 'param2 param1');
