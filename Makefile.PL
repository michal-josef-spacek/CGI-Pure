# $Id: Makefile.PL,v 1.7 2005-11-02 11:53:45 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Spacek',
	'NAME' => 'CGI::Pure',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.01,
		'URI::Escape' => 3.22,
	},
	'VERSION' => 0.01,
);
