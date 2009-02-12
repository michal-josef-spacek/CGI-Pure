#------------------------------------------------------------------------------
package CGI::Pure;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use CGI::Deurl::XS qw(parse_query_string);
use English qw(-no_match_vars);
use Error::Simple::Multiple qw(err);
use List::MoreUtils qw(none);
use Readonly;
use URI::Escape qw(uri_escape uri_unescape);

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $POST_MAX => 102_400;
Readonly::Scalar my $POST_MAX_NO_LIMIT => -1;
Readonly::Scalar my $BLOCK_SIZE => 4_096;
Readonly::Array my @PAR_SEP => ('&', ';');

# Version.
our $VERSION = 0.03;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Disable upload.
	$self->{'disable_upload'} = 1;

	# Init.
	$self->{'init'} = undef;

	# Parameter separator.
	$self->{'par_sep'} = '&';

	# Use a post max of 100K ($POST_MAX),
	# set to -1 ($POST_MAX_NO_LIMIT) for no limits.
	$self->{'post_max'} = $POST_MAX;

	# Save query data from server.
	$self->{'save_query_data'} = 0;

	# Process params.
        while (@params) {
                my $key = shift @params;
                my $val = shift @params;
                err "Unknown parameter '$key'." if ! exists $self->{$key};
                $self->{$key} = $val;
        }

	# Check to parameter separator.
	if (none { $_ eq $self->{'par_sep'} } @PAR_SEP) {
		err "Bad parameter separator '$self->{'par_sep'}'.";
	}

	# Global object variables.
	$self->_global_variables;

	# Initialization.
	my $init = $self->{'init'};
	delete $self->{'init'};
	$self->_initialize($init);

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub append_param {
#------------------------------------------------------------------------------
# Append param value.

	my ($self, $param, @values) = @_;
	$self->_add_param($param, ((defined $values[0] and ref $values[0])
		? $values[0] : [@values]));
	return $self->param($param);
}

#------------------------------------------------------------------------------
sub clone {
#------------------------------------------------------------------------------
# Clone class to my class.

	my ($self, $class) = @_;
	foreach my $param ($class->param) {
		$self->param($param, $class->param($param));
	}
	return;
}

#------------------------------------------------------------------------------
sub delete_param {
#------------------------------------------------------------------------------
# Delete param.

	my ($self, $param) = @_;
	return if ! defined $self->{'.parameters'}->{$param};
	delete $self->{'.parameters'}->{$param};
	return 1;
}

#------------------------------------------------------------------------------
sub delete_all_params {
#------------------------------------------------------------------------------
# Delete all params.

	my $self = shift;
	delete $self->{'.parameters'};
	$self->{'.parameters'} = {};
	return;
}

#------------------------------------------------------------------------------
sub param {
#------------------------------------------------------------------------------
# Return param[s]. If sets parameters, than overwrite.

	my ($self, $param, @values) = @_;

	# Return list of all params.
	if (! defined $param) {
		return keys %{$self->{'.parameters'}};
	}

	# Return values for $param.
	if (! @values) {
		return () if ! exists $self->{'.parameters'}->{$param};

	# Values exists, than sets them.
	} else {
		$self->_add_param($param, (ref $values[0] eq 'ARRAY'
			? $values[0] : [@values]), 'overwrite');
	}

	# Return values of param, or first value of param.
	return wantarray ? @{$self->{'.parameters'}->{$param}}
		: $self->{'.parameters'}->{$param}->[0];
}

#------------------------------------------------------------------------------
sub query_string {
#------------------------------------------------------------------------------
# Return actual query string.

	my $self = shift;
	my @pairs;
	foreach my $param ($self->param) {
		foreach my $value ($self->param($param)) {
			next if ! defined $value;
			push @pairs, $self->_uri_escape($param).'='.
				$self->_uri_escape($value);
		}
	}
	return join($self->{'par_sep'}, @pairs);
}

#------------------------------------------------------------------------------
sub upload {
#------------------------------------------------------------------------------
# Upload file from tmp.

	my ($self, $filename, $writefile) = @_;
	if ($ENV{'CONTENT_TYPE'} !~ m/^multipart\/form-data/ismx) {
		err 'File uploads only work if you specify '.
			'enctype="multipart/form-data" in your form.';
	}
	if (! $filename) {;
		err 'No filename submitted for upload '.
			"to '$writefile'." if $writefile;
		return $self->{'.filehandles'}
			? keys %{$self->{'.filehandles'}} : ();
	}
	my $fh = $self->{'.filehandles'}->{$filename};
	if ($fh) {

		# Get ready for reading.
		seek $fh, 0, 0;

		return $fh if ! $writefile;
		binmode $fh;
		my $buffer;
		my $out;
		if (! open($out, '>', $writefile)) {
			err "Cannot write file '$writefile': $!.";
		}
		binmode $out;
		while (read($fh, $buffer, $BLOCK_SIZE)) {
			print {$out} $buffer;
		}
		if (! close $out) {
			err "Cannot close file '$writefile': $!.";
		}
		$self->{'.filehandles'}->{$filename} = undef;
		undef $fh;
	} else {
		err "No filehandle for '$filename'. ".
			'Are uploads enabled (disable_upload = 0)? '.
			'Is post_max big enough?';
	}
	return;
}

#------------------------------------------------------------------------------
sub upload_info {
#------------------------------------------------------------------------------
# Return informations from uploaded files.

	my ($self, $filename, $info) = @_;
	if ($ENV{'CONTENT_TYPE'} !~ m/^multipart\/form-data/ismx) {
		err 'File uploads only work if you '.
			'specify enctype="multipart/form-data" in your '.
			'form.';
	}
	return keys %{$self->{'.tmpfiles'}} if ! $filename;
	return $self->{'.tmpfiles'}->{$filename}->{'mime'}
		if $info =~ /mime/ism;
	return $self->{'.tmpfiles'}->{$filename}->{'size'};
}

#------------------------------------------------------------------------------
sub query_data {
#------------------------------------------------------------------------------
# Gets query data from server.

	my $self = shift;
	if ($self->{'save_query_data'}) {
		return $self->{'.query_data'};
	} else {
		return 'Not saved query data.';
	}
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _global_variables {
#------------------------------------------------------------------------------
# Sets global object variables.

	my $self = shift;
	$self->{'.parameters'} = {};
	$self->{'.query_data'} = $EMPTY_STR;
	return;
}

#------------------------------------------------------------------------------
sub _initialize {
#------------------------------------------------------------------------------
# Initializating CGI::Pure with something input methods.

	my ($self, $init) = @_;

	# Initialize from QUERY_STRING, STDIN or @ARGV.
	if (! defined $init) {
		$self->_common_parse;

	# Initialize from param hash.
	} elsif (ref $init eq 'HASH') {
		foreach my $param (keys %{$init}) {
			$self->_add_param($param, $init->{$param});
		}

	# Inicialize from CGI::Pure object.
	} elsif (eval { $init->isa('CGI::Pure') }) {
		$self->clone($init);

	# Initialize from a query string.
	} else {
		$self->_parse_params($init);
	}
	return;
}

#------------------------------------------------------------------------------
sub _common_parse {
#------------------------------------------------------------------------------
# Common parsing from any methods..

	my $self = shift;
	my $data;

	# Information from server.
	my $type = $ENV{'CONTENT_TYPE'} || 'No CONTENT_TYPE received';
	my $length = $ENV{'CONTENT_LENGTH'} || 0;
	my $method = $ENV{'REQUEST_METHOD'} || 'No REQUEST_METHOD received';

	# Multipart form data.
	if ($length && $type =~ m/^multipart\/form-data/imsx) {

		# Get data_length, store data to internal structure.
		my $got_data_length = $self->_parse_multipart;

		# Bad data length vs content_length.
		if ($length != $got_data_length) {
			err "500 Bad read! wanted $length, got ".
				"$got_data_length.";
		}

		return;

	# POST method.
	} elsif ($method eq 'POST') {

		# Maximal post length is above my length.
                if ($self->{'post_max'} != $POST_MAX_NO_LIMIT
                        and $length > $self->{'post_max'}) {

                        err '413 Request entity too large: '.
                                "$length bytes on STDIN exceeds ".
                                'post_max !';

		# Get data.
                } elsif ($length) {
			read(STDIN, $data, $length);
		}

		# Save data for post.
		if ($self->{'save_query_data'}) {
			$self->{'.query_data'} = $data;
		}

		# Bad length of data.
		if ($length != length $data) {
			err "500 Bad read! wanted $length, got ".
				(length $data).'.';
		}

	# GET/HEAD method.
	} elsif ($method eq 'GET' || $method eq 'HEAD') {
		$data = $ENV{'QUERY_STRING'} || $EMPTY_STR;
		if ($self->{'save_query_data'}) {
			$self->{'.query_data'} .= $data;
		}
	}

	# Parse params.
	if ($data) {
		$self->_parse_params($data);
	}
	return;
}

#------------------------------------------------------------------------------
sub _add_param {
#------------------------------------------------------------------------------
# Adding param.

	my ($self, $param, $value, $overwrite) = @_;
	return () if ! defined $param;
	if ($overwrite
		|| ! exists $self->{'.parameters'}->{$param}) {

		$self->{'.parameters'}->{$param} = [];
	}
	my @values = ref $value eq 'ARRAY' ? @{$value} : ($value);
	foreach my $value (@values) {
		push @{$self->{'.parameters'}->{$param}}, $value;
	}
	return;
}

#------------------------------------------------------------------------------
sub _parse_params {
#------------------------------------------------------------------------------
# Parse params from data.

	my ($self, $data) = @_;
	return () if ! defined $data;

	# Parse params.
	my $pairs = parse_query_string($data);
	foreach (keys %{$pairs}) {
		$self->_add_param($_, $pairs->{$_});
	}
	return;
}

#------------------------------------------------------------------------------
sub _parse_multipart {
#------------------------------------------------------------------------------
# Parse multipart data.

	my $self = shift;
	my ($boundary) = $ENV{'CONTENT_TYPE'}
		=~ /
			boundary=
			\"?([^\";,]+)\"?
		/xms;
	if (! $boundary) {
		err '400 No boundary supplied for multipart/form-data.';
	}

	# BUG: IE 3.01 on the Macintosh uses just the boundary, forgetting
	# the --
	$boundary = '--'.$boundary
		if $ENV{'HTTP_USER_AGENT'} !~ m/
			MSIE\s+
			3\.0[12];
			\s*
			Mac
		/ixms;

	$boundary = quotemeta $boundary;
	my $got_data_length = 0;
	my $data = $EMPTY_STR;
	my $read;
	my $CRLF = $self->_crlf;

	READ:
	while (read(STDIN, $read, $BLOCK_SIZE)) {

		# Adding post data.
		if ($self->{'save_query_data'}) {
			$self->{'.query_data'} .= $read;
		}

		$data .= $read;
		$got_data_length += length $read;

		BOUNDARY:
		while ($data =~ m/^$boundary$CRLF/sm) {
			my $header;

			# Get header, delimited by first two CRLFs we see.
			if ($data !~ m/^([\040-\176$CRLF]+?$CRLF$CRLF)/ms) {
				next READ;
			}
# XXX Proc tohle nemuze byt? /x tam dela nejake potize.
#			if ($data !~ m/^(
#					[\040-\176$CRLF]+?
#					$CRLF
#					$CRLF
#				)/msx) {
#
#				next READ;
#			}
			$header = $1;

			# Unhold header per RFC822.
			(my $unfold = $1) =~ s/$CRLF\s+/\ /gsm;

			my ($param) = $unfold =~ m/
					form-data;
					\s+
					name="?([^\";]*)"?
				/xms;
			my ($filename) = $unfold =~ m/
					name="?\Q$param\E"?;
					\s+
					filename="?([^\"]*)"?
				/xms;
			if (defined $filename) {
				my ($mime) = $unfold =~ m/
						Content-Type:
						\s+
						([-\w\/]+)
					/isxm;

				# Trim off header.
				$data =~ s/^\Q$header\E//sm;

				($got_data_length, $data, my $fh, my $size)
					= $self->_save_tmpfile($boundary,
					$filename, $got_data_length, $data);

				$self->_add_param($param, $filename);

				# Filehandle.
				$self->{'.filehandles'}->{$filename} = $fh
					if $fh;

				# Information about file.
				if ($size) {
					$self->{'.tmpfiles'}->{$filename} = {
						'size' => $size,
						'mime' => $mime,
					};
				}
				next BOUNDARY;
			}
			if ($data !~ s/^\Q$header\E(.*?)$CRLF(?=$boundary)//s) {
				next READ;
			}
# XXX /x
#			if ($data !~ s/^
#					\Q$header\E
#					(.*?)
#					$CRLF
#					(?=$boundary)
#				//sxm) {
#
#				next READ;
#			}
			$self->_add_param($param, $1);
		}
	}

	# Length of data.
	return $got_data_length;
}

#------------------------------------------------------------------------------
sub _save_tmpfile {
#------------------------------------------------------------------------------
# Save file from multiform.

	my ($self, $boundary, $filename, $got_data_length, $data) = @_;
	my $fh;
	my $CRLF = $self->_crlf;
	my $file_size = 0;
	if ($self->{'disable_upload'}) {
		err '405 Not Allowed - File uploads are disabled.';
	} elsif ($filename) {
		eval {
			require IO::File;
		};
		if ($EVAL_ERROR) {
			err "500 IO::File is not available $EVAL_ERROR.";
		}
		$fh = new_tmpfile IO::File;
		if (! $fh) {
			err '500 IO::File can\'t create new temp_file.';
		}
	}
	binmode $fh;
	while (1) {
		my $buffer = $data;
		read(STDIN, $data, $BLOCK_SIZE);
		if (! $data) {
			$data = $EMPTY_STR;
		}
		$got_data_length += length $data;
		if ("$buffer$data" =~ m/$boundary/ms) {
			$data = $buffer.$data;
			last;
		}

		# BUG: Fixed hanging bug if browser terminates upload part way.
		if (! $data) {
			undef $fh;
			err '400 Malformed multipart, no terminating '.
				'boundary.';
		}

		# We do not have partial boundary so print to file if valid $fh.
		print {$fh} $buffer;
		$file_size += length $buffer;
	}
	$data =~ s/^
		(.*?)
		$CRLF
		(?=$boundary)
	//smx;

	# Print remainder of file if value $fh.
	if ($1) {
		print {$fh} $1;
		$file_size += length $1;
	}

	return $got_data_length, $data, $fh, $file_size;
}

#------------------------------------------------------------------------------
sub _crlf {
#------------------------------------------------------------------------------
# Define the CRLF sequence.

	my ($self, $CRLF) = @_;

	# Allow value to be set manually.
	$self->{'.crlf'} = $CRLF if $CRLF;

	# If not defined.
	if (! $self->{'.crlf'}) {
		$self->{'.crlf'} = ($OSNAME =~ m/VMS/ism) ? "\n" : "\r\n";
	}

	# Return sequence.
	return $self->{'.crlf'};
}

#------------------------------------------------------------------------------
sub _uri_escape {
#------------------------------------------------------------------------------
# Escapes uri.

	my ($self, $string) = @_;
	$string = uri_escape($string);
	$string =~ s/\ /\+/gsm;
	return $string;
}

#------------------------------------------------------------------------------
sub _uri_unescape {
#------------------------------------------------------------------------------
# Unescapes uri.

	my ($self, $string) = @_;
	$string =~ s/\+/\ /gsm;
	return uri_unescape($string);
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

CGI::Pure - Common Gateway Interface Class.

=head1 SYNOPSIS

 use CGI::Pure;
 my $cgi = CGI::Pure->new(%parameters);
 $cgi->append_param('par', 'value');
 my @par_value = $cgi->param('par');
 $cgi->delete_param('par');
 $cgi->delete_all_params;
 my $query_string = $cgi->query_string;
 $cgi->upload('filename', '~/filename');
 my $mime = $cgi->upload_info('filename', 'mime');
 my $query_data = $cgi->query_data;

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor

=over 8

=item * B<disable_upload>

 Disables file upload.
 Default value is 1.

=item * B<init>

 Initialization variable.
 May be:
 - CGI::Pure object.
 - Hash with params.
 - Query string.
 Default is undef.

=item * B<par_sep>

 Parameter separator.
 Default value is '&'.
 Possible values are '&' or ';'.

=item * B<post_max>

 Maximal post length.
 -1 means no limit.
 Default value is 102400kB

=item * B<save_query_data>

 Flag, that means saving query data.
 When is enable, is possible use query_data method.
 Default value is 0.

=back

=item B<append_param($param, [@values])>

 Append param value.
 Return all values for param.

=item B<clone($class)>

 Clone class to my class.

=item B<delete_param($param)>

 Delete param.
 Returns undef, when param doesn't exist.
 Return 1, when param was deleted.

=item B<delete_all_params()>

 Delete all params.

=item B<param([$param], [@values])>

 Returns or sets parameters in CGI.
 params() returns all parameters name.
 params('param') returns parameter 'param' value.
 params('param', 'val1', 'val2') sets parameter 'param' to 'val1' and 'val2' values.

=item B<query_string()>

 Return actual query string.

=item B<upload($filename, [$write_to])>

 Upload file from tmp.
 upload() returns array of uploaded filenames.
 upload($filename) returns handler to uploaded filename.
 upload($filename, $write_to) uploads temporary '$filename' file to '$write_to' file.

=item B<upload_info($filename, [$info])>

 Return informations from uploaded files.
 upload_info() returns array of uploaded files.
 upload_info('filename') returns size of uploaded 'filename' file.
 upload_info('filename', 'mime') returns mime type of uploaded 'filename' file.

=item B<query_data()>

 Gets query data from server.
 There is possible only for enabled 'save_data' flag.

=back

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use CGI::Pure;

 # Object.
 my $query_string = 'par1=val1;par1=val2;par2=value';
 my $cgi = CGI::Pure->new(
         'init' => $query_string,
 );
 foreach ($cgi->param) {
         print "Param '$_': ".join(' ', $cgi->param($_))."\n";
 }

 # Output:
 # Param 'par1': val1 val2
 # Param 'par2': value

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use CGI::Pure;

 # Object.
 my $cgi = CGI::Pure->new;
 $cgi->param('par1', 'val1', 'val2');
 $cgi->param('par2', 'val3');
 $cgi->append_param('par2', 'val4');

 foreach ($cgi->param) {
         print "Param '$_': ".join(' ', $cgi->param($_))."\n";
 }

 # Output:
 # Param 'par2': val3 val4
 # Param 'par1': val1 val2

=head1 DEPENDENCIES

L<CGI::Deurl::XS(3pm)>,
L<Error::Simple::Multiple(3pm)>,
L<URI::Escape(3pm)>.

=head1 SEE ALSO

L<CGI::Pure::Fast(3pm)>,
L<CGI::Pure::ModPerl(3pm)>,
L<CGI::Pure::Save(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

 BSD license.

=head1 VERSION

0.02

=cut
