#!/usr/bin/perl -w
# $Id: use.t,v 1.1 2004-09-08 22:24:09 skim Exp $

# Modules.
use strict;
use Test::Simple tests => 2;
use SCGI;

# Create new object.
my $scgi = new SCGI();

# Check that we got something.
ok(defined $scgi, 'new() returned something');

# And it's the right class.
ok($scgi->isa('SCGI'), 'it\'s the right class');
