#!/usr/bin/env perl

# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure::ModPerl2;
use Test;

# Global variables.:
use vars qw/$debug $class $dir/;

BEGIN {
	# Name of class.
	$dir = $class = 'CGI::Pure::ModPerl2';
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