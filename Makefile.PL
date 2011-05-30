# Pragmas.
use strict;
use warnings;

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Špaček <skim@cpan.org>',
	'NAME' => 'CGI::Pure',
	'PREREQ_PM' => {
		'CGI::Deurl::XS' => 0,
		'Class::Utils' => 0.01,
		'Encode' => 0,
		'English' => 0,
		'Error::Simple::Multiple' => 0.05,
		'IO::File' => 0,
		'List::MoreUtils' => 0,
		'Readonly' => 0,
		'URI::Escape' => 3.22,
	},
	'VERSION' => 0.01,
	'test' => {
		'TESTS' => 't/CGI::Pure/*.t '.
			't/CGI::Pure::Save/*.t',
	},
);
