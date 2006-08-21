# $Id: Makefile.PL,v 1.9 2006-08-21 19:41:02 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Spacek',
	'NAME' => 'CGI::Pure',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.02,
		'FCGI' => 0,
		'URI::Escape' => 3.22,
	},
	'VERSION' => 0.01,
);
