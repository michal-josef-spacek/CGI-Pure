# Pragmas.
use strict;
use warnings;

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Špaček <skim@cpan.org>',
	'BUILD_REQUIRES' => {
		'File::Object' => 0,
		'IO::Scalar' => 0,
		'Test::More' => 0,
		'Test::Pod' => 0,
		'Test::Pod::Coverage' => 0,
	},
	'CONFIGURE_REQUIRES' => {
		'ExtUtils::MakeMaker' => 0,
	},
	'LICENSE' => 'bsd',
	'NAME' => 'CGI::Pure',
	'PREREQ_PM' => {
		'CGI::Deurl::XS' => 0,
		'Class::Utils' => 0.01,
		'Encode' => 0,
		'English' => 0,
		'Error::Pure' => 0.01,
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
