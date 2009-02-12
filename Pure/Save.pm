#------------------------------------------------------------------------------
package CGI::Pure::Save;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Simple::Multiple qw(err);
use Readonly;
use URI::Escape;

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# CGI::Pure object.
	$self->{'cgi_pure'} = $EMPTY_STR;

	# Process params.
        while (@params) {
                my $key = shift @params;
                my $val = shift @params;
                err "Unknown parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# CGI::Pure object not exist.
	if (! $self->{'cgi_pure'} || ! $self->{'cgi_pure'}->isa('CGI::Pure')) {
		err 'CGI::Pure object doesn\'t define.';
	}

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub load {
#------------------------------------------------------------------------------
# Load parameters from file.

	my ($self, $fh) = @_;
	if (! $fh || ! fileno $fh) {
		$self->{'cgi_pure'}->cgi_error('Invalid filehandle.');
		return;
	}
	local $INPUT_RECORD_SEPARATOR = "\n";
	while (my $pair = <$fh>) {
		chomp $pair;
		return 1 if $pair eq '=';
		$self->{'cgi_pure'}->_parse_params($pair);
	}
	return;
}

#------------------------------------------------------------------------------
sub save {
#------------------------------------------------------------------------------
# Save parameters to file.

	my ($self, $fh) = @_;
	local $OUTPUT_FIELD_SEPARATOR = $EMPTY_STR;
	local $OUTPUT_RECORD_SEPARATOR = $EMPTY_STR;
	if (! $fh || ! fileno $fh) {
		$self->{'cgi_pure'}->cgi_error('Invalid filehandle.');
		return;
	}
	foreach my $param ($self->{'cgi_pure'}->param) {
		foreach my $value ($self->{'cgi_pure'}->param($param)) {
			print {$fh} uri_escape($param), '=',
				uri_escape($value), "\n";
		}
	}
	print {$fh} "=\n";
	return 1;
}

1;
