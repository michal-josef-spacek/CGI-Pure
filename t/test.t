#!/usr/bin/perl -w
# $Id: test.t,v 1.2 2004-09-17 00:57:44 skim Exp $

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
}
