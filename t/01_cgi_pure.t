#!/usr/bin/perl -w
# $Id: 01_cgi_pure.t,v 1.2 2004-09-28 18:07:40 skim Exp $

# Modules.
use strict;
use SCGI;
use Test;

# Global variables.:
use vars qw/$debug $obj $class/;

BEGIN {
	my $tests = `grep -r \"^ok(\" t/SCGI/*.t | wc -l`;
	chomp $tests;
	plan('tests' => $tests);

	# Debug.
	$debug = 1;
}

# Name of class.
$class = 'SCGI';

# Prints debug information about class.
print "\nClass '$class'\n" if $debug;

# For every test for this class.
my @list = `ls t/SCGI/*.t`;
foreach (@list) {
	chomp;
	do $_;
	print $@;
}
