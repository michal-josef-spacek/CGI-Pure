#------------------------------------------------------------------------------
package SCGI::Save;
#------------------------------------------------------------------------------
# $Id: Save.pm,v 1.1 2004-09-28 21:02:18 skim Exp $
# Saving and loading query params from file.

# Modules.
use strict;
use Carp;
use URI::Escape;

# Global variables.
use vars qw($VERSION);

# Version.
$SCGI::Save::VERSION = '1.0';

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = {};

	# SCGI object.
	$self->{'scgi'} = '';

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

	# SCGI object not exist.
	unless ($self->{'scgi'} && $self->{'scgi'}->isa('SCGI')) {
		croak "$class: SCGI object doesn't define.";
	}

	# Object.
	return bless $self, $class;
}
# END of new().

#------------------------------------------------------------------------------
sub save {
#------------------------------------------------------------------------------
# Save parameters to file.

	my ($self, $fh) = @_;
	local ($,, $\) = ('', '');
	unless ($fh && fileno $fh) {
		$self->{'scgi'}->cgi_error('Invalid filehandle.');
		return undef;
	}
	foreach my $param ($self->{'scgi'}->param()) {
		foreach my $value ($self->{'scgi'}->param($param)) {
			print $fh uri_escape($param), '=',
				uri_escape($value), "\n";
		}
	}
	print $fh "=\n";
	return 1;
}
# END of save().

#------------------------------------------------------------------------------
sub load {
#------------------------------------------------------------------------------
# Load parameters from file.

	my ($self, $fh) = @_;
	unless ($fh && fileno $fh) {
		$self->{'scgi'}->cgi_error('Invalid filehandle.');
		return undef;
	}
	local $/ = "\n";
	while (my $pair = <$fh>) {
		chomp $pair;
		return 1 if $pair eq '=';
		$self->{'scgi'}->_parse_params($pair);
	}
	return undef;
}
# END of load().

1;
