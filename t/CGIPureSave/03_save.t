# $Id: 03_save.t,v 1.1 2004-09-28 21:02:39 skim Exp $

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/Save";

print "Testing: save(\$fh) - saving parameters from SCGI object.\n" if $debug;
use SCGI;
my $scgi = new SCGI('par=val&par2=val2');
$obj = new $class('scgi' => $scgi);
my $file = "$test_dir/Data/params";
open(OUF, ">$file") || die "Can't open file '$file'.";
my $ret = $obj->save(\*OUF);
ok($ret, 1);
close(OUF);
open(INF, "<$file") || die "Can't read file '$file'.";
my $inf = join('', <INF>);
ok($inf eq "par=val\npar2=val2\n=\n" 
	|| $inf eq "par2=val2\npar=val\n=\n");
close(INF);
unlink $file;
