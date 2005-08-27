#------------------------------------------------------------------------------
package CGI::Pure::Save;
#------------------------------------------------------------------------------
# $Id: Save.pm,v 1.7 2005-08-27 10:44:53 skim Exp $
# Saving and loading query params from file.

# Pragmas.
use strict;

# Modules.
use Error::Simple;
use URI::Escape;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# CGI::Pure object.
	$self->{'cgi_pure'} = '';

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Unknown parameter '$key'." 
			if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# CGI::Pure object not exist.
	unless ($self->{'cgi_pure'} && $self->{'cgi_pure'}->isa('CGI::Pure')) {
		err "CGI::Pure object doesn't define.";
	}

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub load {
#------------------------------------------------------------------------------
# Load parameters from file.

	my ($self, $fh) = @_;
	unless ($fh && fileno $fh) {
		$self->{'cgi_pure'}->cgi_error('Invalid filehandle.');
		return undef;
	}
	local $/ = "\n";
	while (my $pair = <$fh>) {
		chomp $pair;
		return 1 if $pair eq '=';
		$self->{'cgi_pure'}->_parse_params($pair);
	}
	return undef;
}

#------------------------------------------------------------------------------
sub save {
#------------------------------------------------------------------------------
# Save parameters to file.

	my ($self, $fh) = @_;
	local ($,, $\) = ('', '');
	unless ($fh && fileno $fh) {
		$self->{'cgi_pure'}->cgi_error('Invalid filehandle.');
		return undef;
	}
	foreach my $param ($self->{'cgi_pure'}->param()) {
		foreach my $value ($self->{'cgi_pure'}->param($param)) {
			print $fh uri_escape($param), '=',
				uri_escape($value), "\n";
		}
	}
	print $fh "=\n";
	return 1;
}

1;
