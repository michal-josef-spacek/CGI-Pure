# $Id: Makefile.PL,v 1.3 2005-01-08 10:52:09 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'CGI::Pure',
	'VERSION_FROM' => 'Pure.pm',
	'PREREQ_PM' => {
		'URI::Escape' => '3.22',
	},
);
