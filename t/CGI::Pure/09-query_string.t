# Modules.
use CGI::Pure;
use IO::Scalar;
use Test::More 'tests' => 3;

# Test.
my $obj = CGI::Pure->new(
	'init' => {'foo' => '1', 'bar' => [2, 3, 4]},
);
my $ret = $obj->query_string;
is($ret, 'bar=2&bar=3&bar=4&foo=1');

# Test.
$ENV{'CONTENT_LENGTH'} = 32;
$ENV{'REQUEST_METHOD'} = 'POST';
my $tmp = IO::Scalar->new(\"color=red&color=green&color=blue");
local *STDIN = $tmp;
$obj = CGI::Pure->new;
$ret = $obj->query_string;
is($ret, "color=blue&color=green&color=red");

# Test.
# TODO Multipart.

# Test.
$ENV{'QUERY_STRING'} = 'color=red&color=green&color=blue';
$ENV{'REQUEST_METHOD'} = 'GET';
$obj = CGI::Pure->new;
$ret = $obj->query_string;
is($ret, 'color=blue&color=green&color=red');
