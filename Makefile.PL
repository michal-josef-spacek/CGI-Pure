# $Id: Makefile.PL,v 1.11 2008-06-22 11:19:50 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Spacek',
	'NAME' => 'CGI::Pure',
	'PREREQ_PM' => {
		'Error::Simple::Multiple' => 0.04,
		'FCGI' => 0,
		'URI::Escape' => 3.22,
	},
	'VERSION' => 0.02,
);
