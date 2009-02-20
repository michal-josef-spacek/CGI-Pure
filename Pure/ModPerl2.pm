#------------------------------------------------------------------------------
package CGI::Pure::ModPerl2;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(CGI::Pure);
use strict;
use warnings;

# Modules.
use Apache2::RequestIO;
use Apache2::RequestRec;
use Apache2::RequestUtil;
use Apache2::Response;
use APR::Pool;
use Error::Simple::Multiple qw(err);
use mod_perl2;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _initialize {
#------------------------------------------------------------------------------
# Initializating CGI::Pure for mod_perl2 with something input methods.

	my ($self, $init) = @_;

	# Check to mod_perl2.
	if (! $self->_is_mod_perl2) {
		err 'It isn\'t mod_perl2.';
	}

	# mod_perl2 initialization.
	if ($init) {
		$self->{'.mod_perl2_request'} = $init;
		undef $init;
	}
	$self->_initialize_mod_perl;

	# CGI::Pure initialization.
	$self->_initialize($init);

	return;
}

#------------------------------------------------------------------------------
sub _initialize_mod_perl {
#------------------------------------------------------------------------------
# Initialization for mod_perl.

	my ($self, $init) = @_;

	# Initialize mod_perl2.
	if (! exists $self->{'.mod_perl2_request'}) {
		$self->{'.mod_perl2_request'} = Apache2::RequestUtil->request;
	}

	# Mod perl
	my $r = $self->{'.mod_perl2_request'};

	# TODO
	if (! exists $ENV{'REQUEST_METHOD'}) {
		$r->subprocess_env;
	}
	# XXX Cleanup.
#	$r->pool->cleanup_register(
#	);

	return;
}

#------------------------------------------------------------------------------
sub _is_mod_perl2 {
#------------------------------------------------------------------------------
# Is there mod_perl?

	my $self = shift;
	if (exists $ENV{'MOD_PERL'}
		|| ($ENV{'GATEWAY_INTERFACE'} 
		&& $ENV{'GATEWAY_INTERFACE'} =~ m{^CGI-Perl/})) {

		if ($mod_perl::VERSION >= 2.00) {
			$self->{'.mod_perl'} = 2;
			return 1;
		} else {
			return 0;
		}
	} else {
		return 0;
	}
}

1;
