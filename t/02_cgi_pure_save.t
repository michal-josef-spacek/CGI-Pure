#!/usr/bin/perl -w
# $Id: 02_cgi_pure_save.t,v 1.1 2004-09-28 21:03:06 skim Exp $

# Modules.
use strict;
use SCGI::Save;
use Test;

# Global variables.:
use vars qw/$debug $obj $class/;

BEGIN {
	my $tests = `grep -r \"^ok(\" t/Save/*.t | wc -l`;
	chomp $tests;
	plan('tests' => $tests);

	# Debug.
	$debug = 1;
}

# Name of class.
$class = 'SCGI::Save';

# Prints debug information about class.
print "\nClass '$class'\n" if $debug;

# For every test for this class.
my @list = `ls t/Save/*.t`;
foreach (@list) {
	chomp;
	do $_;
	print $@;
}
