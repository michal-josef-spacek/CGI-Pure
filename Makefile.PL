# $Id: Makefile.PL,v 1.2 2004-09-28 18:05:52 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'SCGI',
	'VERSION_FROM' => 'SCGI.pm',
	'PREREQ_PM' => {
		'URI::Escape' => '3.22',
	},
);
