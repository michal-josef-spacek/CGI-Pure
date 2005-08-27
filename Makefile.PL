# $Id: Makefile.PL,v 1.5 2005-08-27 10:43:26 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Spacek',
	'NAME' => 'CGI::Pure',
	'PREREQ_PM' => {
		'Error::Simple' => 0.01
		'URI::Escape' => 3.22,
	},
	'VERSION' => 0.01,
);
