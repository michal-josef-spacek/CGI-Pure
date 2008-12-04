# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Spacek',
	'NAME' => 'CGI::Pure',
	'PREREQ_PM' => {
		'CGI::Deurl::XS' => 0,
		'Error::Simple::Multiple' => 0.04,
		'FCGI' => 0,
		'URI::Escape' => 3.22,
	},
	'VERSION' => 0.03,
);
