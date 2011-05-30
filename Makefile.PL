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
		'Apache2::RequestIO' => 0,
		'CGI::Deurl::XS' => 0,
		'Error::Simple::Multiple' => 0.05,
		'File::Object' => 0,
		'IO::Scalar' => 0,
		'Readonly' => 0,
		'URI::Escape' => 3.22,
	},
	'VERSION' => 0.04,
	'test' => {
		'TESTS' => 't/CGI::Pure/*.t '.
			't/CGI::Pure::Save/*.t',
	},
);
