# $Id: Makefile.PL,v 1.4 2005-08-10 15:10:02 skim Exp $

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'NAME' => 'CGI::Pure',
	'AUTHOR' => 'Michal Spacek',
	'PREREQ_PM' => {
		'URI::Escape' => '3.22',
	},
	'VERSION_FROM' => 'Pure.pm',
);
