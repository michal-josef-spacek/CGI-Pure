#!/usr/bin/perl
# $Id: 02_cgi_pure_save.t,v 1.2 2005-01-07 21:51:24 skim Exp $

# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Pure::Save;
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
$class = 'CGI::Pure::Save';

# Prints debug information about class.
print "\nClass '$class'\n" if $debug;

# For every test for this class.
my @list = `ls t/Save/*.t`;
foreach (@list) {
	chomp;
	do $_;
	print $@;
}
