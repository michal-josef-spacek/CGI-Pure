# $Id: Makefile.PL,v 1.1 2004-09-08 22:24:23 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'SCGI',
	'VERSION_FROM' => 'SCGI.pm',
	'PREREQ_PM' => {},
);
