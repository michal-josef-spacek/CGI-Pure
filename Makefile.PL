# $Id: Makefile.PL,v 1.8 2006-03-23 00:23:32 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Spacek',
	'NAME' => 'CGI::Pure',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.02,
		'URI::Escape' => 3.22,
	},
	'VERSION' => 0.01,
);
