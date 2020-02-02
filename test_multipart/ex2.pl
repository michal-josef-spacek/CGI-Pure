#!/usr/bin/env perl

use strict;
use warnings;

use CGI::Simple;

$ENV{'CONTENT_LENGTH'} = 500;
$ENV{'CONTENT_TYPE'} = 'multipart/form-data; boundary=----------CaaiagjvfHAwuK2Njrx5yG';
my $cgi = CGI::Simple->new;
use Dumpvalue;
my $dump = Dumpvalue->new;
$dump->dumpValues($cgi);

print $cgi->param;
