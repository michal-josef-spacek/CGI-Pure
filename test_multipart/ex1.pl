#!/usr/bin/env perl

use strict;
use warnings;

use CGI::Pure;

$ENV{'HTTP_USER_AGENT'} = 'skim';
$ENV{'CONTENT_LENGTH'} = 489;
$ENV{'CONTENT_TYPE'} = 'multipart/form-data; boundary=----------Twee2DmbxKWJS25OOtEvVS';
my $cgi = CGI::Pure->new;

use Dumpvalue;
my $dump = Dumpvalue->new;
$dump->dumpValues($cgi);

print $cgi->param;
