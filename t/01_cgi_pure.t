#!/usr/bin/perl
# $Id: 01_cgi_pure.t,v 1.3 2005-01-07 21:51:24 skim Exp $

# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure;
use Test;

# Global variables.:
use vars qw/$debug $obj $class/;

BEGIN {
	my $tests = `grep -r \"^ok(\" t/CGI-Pure/*.t | wc -l`;
	chomp $tests;
	plan('tests' => $tests);

	# Debug.
	$debug = 1;
}

# Name of class.
$class = 'CGI::Pure';

# Prints debug information about class.
print "\nClass '$class'\n" if $debug;

# For every test for this class.
my @list = `ls t/CGI-Pure/*.t`;
foreach (@list) {
	chomp;
	do $_;
	print $@;
}
