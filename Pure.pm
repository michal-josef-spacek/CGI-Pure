#------------------------------------------------------------------------------
package SCGI;
#------------------------------------------------------------------------------
# $Id: Pure.pm,v 1.13 2004-12-01 19:50:11 skim Exp $

# Modules.
use URI::Escape;
use Carp;

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

	# Save query data from server.
	$self->{'save_query_data'} = 0;

	# Disable upload.
	$self->{'disable_upload'} = 1;

	# Use a post max of 100K, set to -1 for no limits.
	$self->{'post_max'} = 102_400;

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

	# Bless object.
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
sub upload {
#------------------------------------------------------------------------------
# Upload file from tmp.

	my ($self, $filename, $writefile) = @_;
	unless ($ENV{'CONTENT_TYPE'} =~ m|^multipart/form-data|i) {
		$self->cgi_error('Oops! File uploads only work if you '.
			'specify enctype="multipart/form-data" in your '.
			'form.');
		return undef;
	}
	unless ($filename) {;
		$self->cgi_error("No filename submitted for upload ".
			"to $writefile.") if $writefile;
		return $self->{'.filehandles'} 
			? keys %{$self->{'.filehandles'}} : ();
	}
	my $fh = $self->{'.filehandles'}->{$filename};
	if ($fh) {

		# Get ready for reading.
		seek $fh, 0, 0;

		return $fh unless $writefile;
		my $buffer;
		unless (open(OUT, ">$writefile")) {
			$self->cgi_error("500 Can't write to ".
				"$writefile: $!\n");
			return undef;
		}
		binmode OUT;
		binmode $fh;
		print OUT $buffer while read($fh, $buffer, 4096);
		close OUT;
		$self->{'.filehandles'}->{$filename} = undef;
		undef $fh;
		return 1;
	} else {
		$self->cgi_error("No filehandle for '$filename'. ".
			"Are uploads enabled (disable_upload = 0)? ".
			"Is post_max big enough?");
		return undef;
	}
}
# END of upload().

#------------------------------------------------------------------------------
sub upload_info {
#------------------------------------------------------------------------------
# Return the file size of an uploaded file.

	my ($self, $filename, $info) = @_;
	unless ($ENV{'CONTENT_TYPE'} =~ m|^multipart/form-data|i) {
		$self->cgi_error('Oops! File uploads only work if you '.
			'specify enctype="multipart/form-data" in your '.
			'form.');
		return undef;
	}
	return keys %{$self->{'.tmpfiles'}} unless $filename;
	return $self->{'.tmpfiles'}->{$filename}->{'mime'} if $info =~ /mime/i;
	return $self->{'.tmpfiles'}->{$filename}->{'size'};
}
# END of upload_info().

#------------------------------------------------------------------------------
sub cgi_error {
#------------------------------------------------------------------------------
# Returns croak/carp error output.

	my ($self, $error) = @_;
	push @{$self->{'.cgi_error'}}, $error if $error;
	return wantarray ? @{$self->{'.cgi_error'}} : $self->{'.cgi_error'};
}
# END of cgi_error().

#------------------------------------------------------------------------------
sub query_data {
#------------------------------------------------------------------------------
# Gets query data from server.

	my $self = shift;
	if ($self->{'save_query_data'}) {
		return $self->{'.query_data'};
	} else {
		return "Not saved query data.";
	}
}
# END of query_data().

#------------------------------------------------------------------------------
# Internal methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _global_variables {
#------------------------------------------------------------------------------
# Sets global object variables.

	my $self = shift;
	$self->{'.parameters'} = {};
	$self->{'.query_data'} = '';
	$self->{'.cgi_error'} = [];
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
			$self->cgi_error("Can't clone SCGI ".
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

	# Information from server.
	my $type = $ENV{'CONTENT_TYPE'} || 'No CONTENT_TYPE received';
	my $length = $ENV{'CONTENT_LENGTH'} || 0;
	my $method = $ENV{'REQUEST_METHOD'} || 'No REQUEST_METHOD received';

	# Multipart form data.
	if ($length && $type =~ m|^multipart/form-data|i) {

		# Get data_length, store data to internal structure.
		my $got_data_length = $self->_parse_multipart();

		# Bad data length vs content_length.
		$self->cgi_error("500 Bad read! wanted $length, ".
			"got $got_data_length") 
			unless $length == $got_data_length;
		return;

	# POST method.
	} elsif ($method eq 'POST') {

		# Maximal post length is above my length.
                if ($self->{'post_max'} != -1
                        and $length > $self->{'post_max'}) {
                        $self->cgi_error("413 Request entity too large: ".
                                "$length bytes on STDIN exceeds ".
                                "post_max !");
                        return;

		# Get data.
                } elsif ($length) {
			read(STDIN, $data, $length) if $length > 0;
		}

		# Save data for post.
		$self->{'.query_data'} = $data if $self->{'save_query_data'};

		# Bad length of data.
		unless ($length == length $data) {
			$self->cgi_error("500 Bad read! wanted ".
				"$length, got ".(length $data));
			return;
		}
	
	# GET/HEAD method.	
	} elsif ($method eq 'GET' || $method eq 'HEAD') {
		$data = $ENV{'QUERY_STRING'} || '';
		$self->{'.query_data'} .= $data if $self->{'save_query_data'};
	}

	# Don't have a data.
	unless ($data) {
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

	my $self = shift;
	my ($boundary) = $ENV{'CONTENT_TYPE'} =~ /boundary=\"?([^\";,]+)\"?/;
	unless ($boundary) {
		$self->cgi_error('400 No boundary supplied for '.
			'multipart/form-data');
		return 0;
	}

	# BUG: IE 3.01 on the Macintosh uses just the boundary, forgetting
	# the --
	$boundary = '--'.$boundary
		unless $ENV{'HTTP_USER_AGENT'} =~ m/MSIE\s+3\.0[12];\s*Mac/i;

	$boundary = quotemeta $boundary;
	my $got_data_length = 0;
	my $data = '';
	my $CRLF = $self->_crlf();
	
	READ:
	while (read(STDIN, $read, 4096)) {

		# Adding post data.
		$self->{'.query_data'} .= $read if $self->{'save_query_data'};

		$data .= $read;
		$got_data_length += length $read;

		BOUNDARY:
		while ($data =~ m/^$boundary$CRLF/) {
			
			# Get header, delimited by first two CRLFs we see.
			next READ unless $data
				=~ m/^([\040-\176$CRLF]+?$CRLF$CRLF)/o;
			my $header = $1;

			# Unhold header per RFC822.
			(my $unfold = $1) =~ s/$CRLF\s+/ /og;

			my ($param) = $unfold
				=~ m/form-data;\s+name="?([^\";]*)"?/;

			# TODO 80 chars?
			my ($filename) = $unfold
				=~ m/name="?\Q$param\E"?;\s+filename="?([^\"]*)"?/;
			if (defined $filename) {
				my ($mime) = $unfold
					=~ m/Content-Type:\s+([-\w\/]+)/io;

				# Trim off header.
				$data =~ s/^\Q$header\E//;

				($got_data_length, $data, my $fh, my $size)
					= $self->_save_tmpfile($boundary,
					$filename, $got_data_length, $data);

				$self->_add_param($param, $filename);

				# Filehandle.
				$self->{'.filehandles'}->{$filename} = $fh
					if $fh;
			
				# Information about file.	
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

	# Length of data.
	return $got_data_length;
}
# END of _parse_multipart().

#------------------------------------------------------------------------------
sub _save_tmpfile {
#------------------------------------------------------------------------------
# Save file from multiform.

	my $self = shift;
	my ($boundary, $filename, $got_data_length, $data) = @_;
	my $fh;
	my $CRLF = $self->_crlf();
	my $file_size = 0;

        if ($self->{'disable_upload'}) {
                $self->cgi_error("405 Not Allowed - File uploads are ".
                        "disabled");
        } elsif ($filename) {
                eval { require IO::File };
                $self->cgi_error("500 IO::File is not available $@") if $@;
                $fh = new_tmpfile IO::File;
                $self->cgi_error("500 IO::File can't create new temp_file")
                        unless $fh;
        }

	binmode $fh if $fh;
	while (1) {
		my $buffer = $data;
		read(STDIN, $data, 4096);
		if (! $data) { $data = ''; }
		$got_data_length += length $data;
		if ("$buffer$data" =~ m/$boundary/) {
			$data = $buffer.$data;
			last;
		}

		# Fixed hanging bug if browser terminates upload part way.
		unless ($data) {
			$self->cgi_error('400 Malformed multipart, no '.
				'terminating boundary');
			undef $fh;
			return $got_data_length;
		}

		# We do not have partial boundary so print to file if valid $fh.
		print $fh $buffer if $fh;
		$file_size += length $buffer;
	}
	$data =~ s/^(.*?)$CRLF(?=$boundary)//s;

	# Print remainder of file if valie $fh.
	print $fh $1 if $fh;
	$file_size += length $1;
	return $got_data_length, $data, $fh, $file_size;
}
# END of _save_tmpfile().

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
