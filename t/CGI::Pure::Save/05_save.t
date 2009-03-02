# Tests directory.
my $test_dir = "$ENV{'PWD'}/t/CGI::Pure::Save";

# Modules.
use CGI::Pure;
use CGI::Pure::Save;
use Test::More 'tests' => 2;

print "Testing: save(\$fh) - saving parameters from CGI::Pure object.\n";
my $cgi_pure = CGI::Pure->new('init' => 'par=val&par2=val2');
my $obj = CGI::Pure::Save->new('cgi_pure' => $cgi_pure);
my $file = "$test_dir/data/params";
open my $ouf, '>', $file || die "Can't open file '$file'.";
my $ret = $obj->save($ouf);
is($ret, 1);
close $ouf;
open my $inf, '<', $file || die "Can't read file '$file'.";
my $inf_string = join q{}, <$inf>;
ok($inf_string eq "par=val\npar2=val2\n=\n" 
	|| $inf_string eq "par2=val2\npar=val\n=\n");
close $inf;
unlink $file;
