#------------------------------------------------------------------------------
package CGI::Pure::Save;
#------------------------------------------------------------------------------
# $Id: Save.pm,v 1.6 2005-08-09 08:25:50 skim Exp $
# Saving and loading query params from file.

# Pragmas.
use strict;

# Modules.
use Carp;
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
	croak "$class: Created with odd number of parameters - should be ".
		"of the form option => value." if (@_ % 2);
	for (my $x = 0; $x <= $#_; $x += 2) {
		if (exists $self->{$_[$x]}) {
			$self->{$_[$x]} = $_[$x+1];
		} else {
			croak "$class: Bad parameter '$_[$x]'.";
		}
	}

	# CGI::Pure object not exist.
	unless ($self->{'cgi_pure'} && $self->{'cgi_pure'}->isa('CGI::Pure')) {
		croak "$class: CGI::Pure object doesn't define.";
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
