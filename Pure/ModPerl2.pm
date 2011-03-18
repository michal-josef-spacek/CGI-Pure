package CGI::Pure::ModPerl2;

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

# Initializating CGI::Pure for mod_perl2 with something input methods.
sub _initialize {
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

# Initialization for mod_perl.
sub _initialize_mod_perl {
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

# Is there mod_perl?
sub _is_mod_perl2 {
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

__END__

=pod

=encoding utf8

=head1 NAME

CGI::Pure::ModPerl2 - TODO

=head1 SYNOPSIS

 use CGI::Pure::ModPerl2;
 my $cgi = CGI::Pure::ModPerl2->new(%parameters);
 TODO

=head1 METHODS

=over 8

 Extends CGI::Pure.
 All methods are same as CGI::Pure.

=back

=head1 EXAMPLE

TODO

=head1 DEPENDENCIES

L<Apache2::RequestIO(3pm)>,
L<Apache2::RequestRec(3pm)>,
L<Apache2::RequestUtil(3pm)>,
L<Apache2::Response(3pm)>,
L<APR::Pool(3pm)>,
L<CGI::Pure(3pm)>,
L<Error::Simple::Multiple(3pm)>,
L<mod_perl2(3pm)>.

=head1 SEE ALSO

L<CGI::Pure(3pm)>.
L<CGI::Pure::Fast(3pm)>,
L<CGI::Pure::Save(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
