#!/usr/bin/env perl
# $Id: 03_cgi_pure_fast.t,v 1.1 2006-02-22 00:15:30 skim Exp $

# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure::Fast;
use Test;

# Global variables.:
use vars qw/$debug $class $dir/;

BEGIN {
	# Name of class.
	$dir = $class = 'CGI::Pure::Fast';
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
