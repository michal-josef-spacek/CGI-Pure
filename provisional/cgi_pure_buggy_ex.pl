#!/usr/bin/perl -w
# $Id: cgi_pure_buggy_ex.pl,v 1.1 2004-08-28 11:04:59 skim Exp $

# Modules.
use strict;
use SCGI::Buggy;

# SCGI object.
my $scgi = new SCGI::Buggy();
$scgi->pokus();
