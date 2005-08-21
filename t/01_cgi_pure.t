#!/usr/bin/env perl
# $Id: 01_cgi_pure.t,v 1.5 2005-08-21 09:44:09 skim Exp $

# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure;
use Test;

# Global variables.:
use vars qw/$debug $class $dir/;

BEGIN {
	# Name of class.
	$dir = $class = 'CGI::Pure';
	$dir =~ s/:://g;

	my $tests = `egrep -r \"^[[:space:]]*ok\\(\" t/$dir/*.t | wc -l`;
	chomp $tests;
	plan('tests' => $tests);

	# Debug.
	$debug = 1;
}

# Prints debug information about class.
print "\nClass '$class'\n" if $debug;

# For every test for this class.
my @list = `ls t/$dir/*.t`;
foreach (@list) {
	chomp;
	do $_;
	print $@;
}
