#!/usr/bin/perl -w
# $Id: 01_cgi_pure.t,v 1.1 2004-09-27 13:52:35 skim Exp $

# Modules.
use strict;
use SCGI;
use Test;

# Global variables.
use vars qw/$debug $q/;

BEGIN {
	my $tests = `grep -r \"^ok(\" t/test/*.t | wc -l`;
	chomp $tests;
	plan('tests' => $tests);

	# Debug.
	$debug = 1;
}

my @list = `ls t/test/*.t`;
foreach (@list) {
	chomp;
	do $_;
	print $@;
}
