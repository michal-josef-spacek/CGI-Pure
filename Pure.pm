#------------------------------------------------------------------------------
package SCGI;
#------------------------------------------------------------------------------
# $Id: Pure.pm,v 1.8 2004-10-02 12:56:00 skim Exp $

# Modules.
use URI::Escape;

# Global variables.
use vars qw($VERSION);

# Version.
$SCGI::VERSION = '1.0';

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $init = shift;
	my $self = {};
	bless $self, $class;

	# Global object variables.
	$self->_global_variables();
	
	# Inicialization.
	$self->_initialize($init);

	# Object.
	return $self;
}
# END of new().

#------------------------------------------------------------------------------
sub DESTROY {
#------------------------------------------------------------------------------
# Destroy object.

        my $self = shift;
        undef $self;
}
# END of DESTROY().

#------------------------------------------------------------------------------
sub param {
#------------------------------------------------------------------------------
# Return param[s]. If sets parameters, than overwrite.

	my $self = shift;
	my $param = shift;
	my @values = @_;

	# Return list of all params.	
	unless (defined $param) {
		return keys %{$self->{'.parameters'}};
	}

	# Return values for $param.
	unless (@values) {
		return () unless exists $self->{'.parameters'}->{$param};

	# Values exists, than sets them.
	} else {
		$self->_add_param($param, (ref $values[0] eq 'ARRAY' 
			? $values[0] : [@values]), 'overwrite');
	}

	# Return values of param, or first value of param.
	return wantarray ? @{$self->{'.parameters'}->{$param}}
		: $self->{'.parameters'}->{$param}->[0];
}
# END of param().

#------------------------------------------------------------------------------
sub append_param {
#------------------------------------------------------------------------------
# Append param value.

	my $self = shift;
	my ($param, @values) = @_;
	return () unless defined $param;
	$self->_add_param($param, ((defined $values[0] and ref $values[0]) 
		? $values[0] : [@values]));
	return $self->param($param);
}
# END of append_param().

#------------------------------------------------------------------------------
sub delete_param {
#------------------------------------------------------------------------------
# Delete param.

	my $self = shift;
	my $param = shift;
	return () unless defined $param;
	return undef unless defined $self->{'.parameters'}->{$param};
	delete $self->{'.parameters'}->{$param};
	return 1;
}
# END of delete_param().

#------------------------------------------------------------------------------
sub delete_all_params {
#------------------------------------------------------------------------------
# Delete all params.

	my $self = shift;
	delete $self->{'.parameters'};
	$self->{'.parameters'} = {};	
}
# END of delete_all_params().

#------------------------------------------------------------------------------
sub query_string {
#------------------------------------------------------------------------------
# Return actual query string.

	my $self = shift;
	my @pairs;
	foreach my $param ($self->param()) {
		foreach my $value ($self->param($param)) {
			next unless defined $value;
			push @pairs, uri_escape($param).'='.
				uri_escape($value);
		}
	}
	return join('&', @pairs);
}
# END of query_string().

#------------------------------------------------------------------------------
sub cgi_error {
#------------------------------------------------------------------------------
# Returns croak/carp error output.

	my ($self, $error) = @_;

	# TODO Fatal errors in croak/carp output? 
	#if ($error) {
	#}
	return $error;
}
# END of cgi_error().

#------------------------------------------------------------------------------
# Internal methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _global_variables {
#------------------------------------------------------------------------------
# Sets global object variables.

	my $self = shift;
	$self->{'.parameters'} = {};
}
# END of _global_variables().

#------------------------------------------------------------------------------
sub _initialize {
#------------------------------------------------------------------------------
# Initializating SCGI with something input methods.

	my ($self, $init) = @_;
	
	# Initialize from QUERY_STRING, STDIN or @ARGV.
	if (! defined $init) {
		$self->_common_parse();

	# Initialize from param hash.	
	} elsif (ref $init eq 'HASH') {
		foreach my $param (keys %{$init}) {
			$self->_add_param($param, $init->{$param});
		}

	# Inicialize from SCGI object.
	} elsif (ref $init eq 'SCGI') {
		eval (require Data::Dumper);
		if ($@) {
			$self->cgi_error("Can't clone CGI::Simple ".
				"object: $@");
			return;
		}

		# Avoid problems with strict when Data::Dumper returns $VAR1.
		my $VAR1;

		# Clone.
		my $clone = eval(Data::Dumper::Dumper($init));
		if ($@) {
			$self->cgi_error("Can't clone CGI::Simple ".
				"object: $@");
		} else {
			$_[0] = $clone;
		}

	# Initialize from a query string.
	} else {
		$self->_parse_params($init);
	}
}
# END of _initialize().

#------------------------------------------------------------------------------
sub _common_parse {
#------------------------------------------------------------------------------
# Common parsing from any methods..

	my $self = shift;
	my $data;

	# TODO Is 'No CON...' right?
	my $type = $ENV{'CONTENT_TYPE'} || 'No CONTENT_TYPE received';
	my $length = $ENV{'CONTENT_LENGTH'} || 0;

	# TODO Is 'No REQ...' right?
	my $method = $ENV{'REQUEST_METHOD'} || 'No REQUEST_METHOD received';

	# Multipart form data.
	# TODO Multipart in CGI?
	if ($length && $type =~ m|^multipart/form-data|i) {
		my $got_length = $self->_parse_multipart();

		# TODO Is this right?
		$self->cgi_error("500 Bad read! wanted $length, ".
			"got $got_length") unless $length == $got_length;
		return;

	# POST method.
	# TODO POST_MAX?
	} elsif ($method eq 'POST') {
		# TODO Must be a content-length?
		if ($length) {
			read(STDIN, $data, $length) if $length > 0;
		}

		# TODO Prevent warnings.
		$data ||= '';

		unless ($length == length $data) {
			$self->cgi_error("500 Bad read! wanted ".
				"$length, got ".(length $data));
			return;
		}
	
	# GET/HEAD method.	
	} elsif ($method eq 'GET' || $method eq 'HEAD') {
		$data = $ENV{'QUERY_STRING'} || '';
	}
	# TODO Others method?

	# Don't have a data.
	unless ($data) {
		# TODO Is this right?
		$self->cgi_error("400 No data received via method: ".
			"$method, type: $type");
		return;
	}

	# Parse params.
	$self->_parse_params($data);
}
# END of _common_parse().

#------------------------------------------------------------------------------
sub _add_param {
#------------------------------------------------------------------------------
# Adding param.

	my $self = shift;
	my ($param, $value, $overwrite) = @_;
	return () unless defined $param and defined $value;
	@{$self->{'.parameters'}->{$param}} = () if $overwrite;
	@{$self->{'.parameters'}->{$param}} = () 
		unless exists $self->{'.parameters'}->{$param};
	my @values = ref $value eq 'ARRAY' ? @{$value} : ($value);
	foreach my $value (@values) {
		push @{$self->{'.parameters'}->{$param}}, $value;
	}	
}
# END of _add_param().

#------------------------------------------------------------------------------
sub _parse_params {
#------------------------------------------------------------------------------
# Parse params from data.

	my $self = shift;
	my $data = shift;
	return () unless defined $data;	

	# Parse params.
	my @pairs = split(/&/, $data);
	foreach my $pair (@pairs) {
		my ($param, $value) = split('=', $pair);
		next unless defined $param;
		$value = '' unless defined $value;
		$self->_add_param(uri_unescape($param),
			uri_unescape($value));
	}
}
# END of _parse_params().

#------------------------------------------------------------------------------
sub _parse_multipart {
#------------------------------------------------------------------------------
# Parse multipart data.
# TODO In CGI?

	my $self = shift;
	my ($boundary) = $ENV{'CONTENT_TYPE'} =~ /boundary=\"?([^\";,]+)\"?/;
	unless ($boundary) {
		$self->cgi_error('400 No boundary supplied for '.
			'multipart/form-data');
		return 0;
	}
	$boundary = quotemeta $boundary;
	my $got_data = 0;
	my $data = '';
	my $CRLF = $self->_crlf();
	
	READ:
	while (my $read = _read_data()) {
		$data .= $read;
		$got_data += length $read;

		BOUNDARY:
		while ($data =~ m/^$boundary$CRLF/) {
			
			# Get header, delimited by first two CRLFs we see.
			next READ unless $data
				=~ m/^([\040-\176$CRLF]+?$CRLF$CRLF)/o;
			my $header = $1;

			# Unhold header per RFC822
			(my $unfold = $1) =~ s/$CRLF\s+/ /og;

			my $param = $unfold
				=~ m/form-data;\s+name="?([^\";]*)"?/;

			# TODO 80 chars?
			my $filename = $unfold
				=~ m/name="?\Q$param\E"?;\s+filename="?([^\"]*)"?/;
			if (defined $filename) {
				my $mime = $unfold
					=~ m/Content-Type:\s+([-\w\/]+)/io;

				# Trim off header.
				$data =~ s/^\Q$header\E//;

				($got_data, $data, my $fh, my $size)
					= $self->_save_tmpfile($boundary,
					$filename, $got_data, $data);
				$self->_add_param($param, $filename);

				# TODO Why .filehandle variable?
				$self->{'.filehandles'}->{$filename} = $fh
					if $fh;
				
				# TODO Why .tmpfile variable?
				$self->{'.tmpfiles'}->{$filename}
					= {'size' => $size, 'mime' => $mime }
					if $size;
				next BOUNDARY;
			}
			next READ unless $data
				=~ s/^\Q$header\E(.*?)$CRLF(?=$boundary)//s;
			$self->_add_param($param, $1);
		}
	}
	return $got_data;
}
# END of _parse_multipart().

#------------------------------------------------------------------------------
sub _save_tmpfile {
#------------------------------------------------------------------------------
# TODO

	my $self = shift;
	my ($boundary, $filename, $got_data, $data) = @_;
	my $fh;
	my $CRLF = $self->_crlf();
	my $file_size = 0;

	# TODO Disable download?

	if ($filename) {
		eval { require IO::File };
		$self->cgi_error("500 IO::File is not available $@") if $@;
		$fh = new_tmpfile IO::File;
		$self->cgi_error("500 IO::File can't create new temp_file")
			unless $fh;
	}

	binmode $fh if $fh;
	while (1) {
		my $buffer = $data;
		$data = _read_data() || '';
		$got_data += length $data;
		if ("$buffer$data" =~ m/$boundary/) {
			$data = $buffer.$data;
			last;
		}

		# Fixed hanging bug if browser terminates upload part way.
		unless ($data) {
			$self->cgi_error('400 Malformed multipart, no '.
				'terminating boundary');
			undef $fh;
			return $got_data;
		}

		# We do not have partial boundary so print to file if valid $fh.
		print $fh $buffer if $fh;
		$file_size += length $buffer;
	}
	$data =~ s/^(.*?)$CRLF(?=$boundary)//s;

	# Print remainder of file if valie $fh.
	print $fh $1 if $fh;
	$file_size += length $1;
	return $got_data, $data, $fh, $file_size;
}
# END of _save_tmpfile().

#------------------------------------------------------------------------------
sub _read_data {
#------------------------------------------------------------------------------
# TODO Why?

	read(STDIN, my $buffer, 4096);
	return $buffer;
}
# END of _read_data().

#------------------------------------------------------------------------------
sub _crlf {
#------------------------------------------------------------------------------
# Define the CRLF sequence.

	my ($self, $CRLF) = @_;

	# Allow value to be set manually.
	$self->{'.crlf'} = $CRLF if $CRLF;

	# If not defined.
	unless ($self->{'.crlf'}) {
		my $OS = $^O;
		$self->{'.crlf'} = ($OS =~ m/VMS/i) ? "\n" : "\r\n";
	}

	# Return sequence.
	return $self->{'.crlf'};
}
# END of _crlf().

1;
