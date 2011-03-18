package CGI::Pure::Save;

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

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# CGI::Pure object.
	$self->{'cgi_pure'} = $EMPTY_STR;

	# Process params.
        while (@params) {
                my $key = shift @params;
                my $val = shift @params;
		if (! exists $self->{$key}) {
	                err "Unknown parameter '$key'.";
		}
                $self->{$key} = $val;
        }

	# CGI::Pure object not exist.
	if (! $self->{'cgi_pure'} || ! $self->{'cgi_pure'}->isa('CGI::Pure')) {
		err 'CGI::Pure object doesn\'t define.';
	}

	# Object.
	return $self;
}

# Load parameters from file.
sub load {
	my ($self, $fh) = @_;
	if (! $fh || ! fileno $fh) {
		$self->{'cgi_pure'}->cgi_error('Invalid filehandle.');
		return;
	}
	local $INPUT_RECORD_SEPARATOR = "\n";
	while (my $pair = <$fh>) {
		chomp $pair;
		if ($pair eq q{=}) {
			return 1;
		}
		$self->{'cgi_pure'}->_parse_params($pair);
	}
	return;
}

# Save parameters to file.
sub save {
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

__END__

=pod

=encoding utf8

=head1 NAME

CGI::Pure::Save - TODO

=head1 SYNOPSIS

 use CGI::Pure::Save;
 my $cgi = CGI::Pure::Save->new(%parameters);
 TODO

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor

=over 8

=item * B<cgi_pure>

 TODO

=back

=item B<load(TODO)>

 TODO

=item B<save(TODO)>

 TODO

=back

=head1 EXAMPLE

TODO

=head1 DEPENDENCIES

L<English(3pm)>,
L<Error::Simple::Multiple(3pm)>,
L<Readonly(3pm)>,
L<URI::Escape(3pm)>.

=head1 SEE ALSO

L<CGI::Pure(3pm)>.
L<CGI::Pure::Fast(3pm)>,
L<CGI::Pure::ModPerl2(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
