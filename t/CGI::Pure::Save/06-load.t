# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure;
use CGI::Pure::Save;
use File::Object;
use Test::More 'tests' => 2;

# Directories.
my $data_dir = File::Object->new->up->dir('data')->serialize;

my $cgi_pure = CGI::Pure->new;
my $obj = CGI::Pure::Save->new('cgi_pure' => $cgi_pure);
my $file = "$data_dir/params2";
open my $inf, $file || die "Can't open file '$file'.";
my $ret = $obj->load($inf);
is($ret, 1);
close $inf;
my @params = $cgi_pure->param;
ok((join q{ }, @params) eq 'param1 param2' 
	|| (join q{ }, @params) eq 'param2 param1');
