# $Id: 03_save.t,v 1.4 2005-08-21 09:45:24 skim Exp $

# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/CGIPureSave";

print "Testing: save(\$fh) - saving parameters from CGI::Pure object.\n" 
	if $debug;
use CGI::Pure;
my $cgi_pure = CGI::Pure->new('par=val&par2=val2');
my $obj = $class->new('cgi_pure' => $cgi_pure);
my $file = "$test_dir/data/params";
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
