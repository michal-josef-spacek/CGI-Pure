#------------------------------------------------------------------------------
package CGI::Pure;
#------------------------------------------------------------------------------
# $Id: Pure.pm,v 1.36 2007-04-06 22:12:10 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple;
use URI::Escape qw(uri_escape uri_unescape);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new($%) {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Disable upload.
	$self->{'disable_upload'} = 1;

	# Init.
	$self->{'init'} = undef;

	# Use a post max of 100K, set to -1 for no limits.
	$self->{'post_max'} = 102_400;

	# Save query data from server.
	$self->{'save_query_data'} = 0;

	# Process params.
        while (@_) {
                my $key = shift;
                my $val = shift;
                err "Unknown parameter '$key'." unless exists $self->{$key};
                $self->{$key} = $val;
        }

	# Global object variables.
	$self->_global_variables;
	
	# Inicialization.
	my $init = $self->{'init'};
	delete $self->{'init'};
	$self->_initialize($init);

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub param($;$@) {
#------------------------------------------------------------------------------
# Return param[s]. If sets parameters, than overwrite.

	my ($self, $param, @values) = @_;

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

#------------------------------------------------------------------------------
sub append_param($;$@) {
#------------------------------------------------------------------------------
# Append param value.

	my ($self, $param, @values) = @_;
	return () unless defined $param;
	$self->_add_param($param, ((defined $values[0] and ref $values[0]) 
		? $values[0] : [@values]));
	return $self->param($param);
}

#------------------------------------------------------------------------------
sub delete_param($;$) {
#------------------------------------------------------------------------------
# Delete param.

	my ($self, $param) = @_;
	return () unless defined $param;
	return undef unless defined $self->{'.parameters'}->{$param};
	delete $self->{'.parameters'}->{$param};
	return 1;
}

#------------------------------------------------------------------------------
sub delete_all_params($) {
#------------------------------------------------------------------------------
# Delete all params.

	my $self = shift;
	delete $self->{'.parameters'};
	$self->{'.parameters'} = {};	
}

#------------------------------------------------------------------------------
sub query_string($) {
#------------------------------------------------------------------------------
# Return actual query string.

	my $self = shift;
	my @pairs;
	foreach my $param ($self->param) {
		foreach my $value ($self->param($param)) {
			next unless defined $value;
			push @pairs, $self->_uri_escape($param).'='.
				$self->_uri_escape($value);
		}
	}
	return join('&', @pairs);
}

#------------------------------------------------------------------------------
sub upload($$$) {
#------------------------------------------------------------------------------
# Upload file from tmp.

	my ($self, $filename, $writefile) = @_;
	unless ($ENV{'CONTENT_TYPE'} =~ m|^multipart/form-data|i) {
		err 'Oops! File uploads only work if you specify '.
			'enctype="multipart/form-data" in your form.';
	}
	unless ($filename) {;
		err "No filename submitted for upload ".
			"to $writefile." if $writefile;
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
			err "500 Can't write to $writefile: $!.";
		}
		binmode OUT;
		binmode $fh;
		print OUT $buffer while read($fh, $buffer, 4096);
		close OUT;
		$self->{'.filehandles'}->{$filename} = undef;
		undef $fh;
	} else {
		err "No filehandle for '$filename'. ".
			"Are uploads enabled (disable_upload = 0)? ".
			"Is post_max big enough?";
	}
}

#------------------------------------------------------------------------------
sub upload_info($$$) {
#------------------------------------------------------------------------------
# Return the file size of an uploaded file.

	my ($self, $filename, $info) = @_;
	unless ($ENV{'CONTENT_TYPE'} =~ m|^multipart/form-data|i) {
		err 'Oops! File uploads only work if you '.
			'specify enctype="multipart/form-data" in your '.
			'form.';
	}
	return keys %{$self->{'.tmpfiles'}} unless $filename;
	return $self->{'.tmpfiles'}->{$filename}->{'mime'} if $info =~ /mime/i;
	return $self->{'.tmpfiles'}->{$filename}->{'size'};
}

#------------------------------------------------------------------------------
sub query_data($) {
#------------------------------------------------------------------------------
# Gets query data from server.

	my $self = shift;
	if ($self->{'save_query_data'}) {
		return $self->{'.query_data'};
	} else {
		return "Not saved query data.";
	}
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _global_variables($) {
#------------------------------------------------------------------------------
# Sets global object variables.

	my $self = shift;
	$self->{'.parameters'} = {};
	$self->{'.query_data'} = '';
}

#------------------------------------------------------------------------------
sub _initialize($;$) {
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
	} elsif (ref $init eq 'CGI::Pure') {
		eval (require Data::Dumper);
		if ($@) {
			err "Can't clone CGI::Pure object: $@";
		}

		# Avoid problems with strict when Data::Dumper returns $VAR1.
		my $VAR1;

		# Clone.
		my $clone = eval(Data::Dumper::Dumper($init));
		if ($@) {
			err "Can't clone CGI::Pure object: $@.";
		} else {
			$_[0] = $clone;
		}

	# Initialize from a query string.
	} else {
		$self->_parse_params($init);
	}
}

#------------------------------------------------------------------------------
sub _common_parse($) {
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
		my $got_data_length = $self->_parse_multipart;

		# Bad data length vs content_length.
		err "500 Bad read! wanted $length, got $got_data_length."
			unless $length == $got_data_length;

		return;

	# POST method.
	} elsif ($method eq 'POST') {

		# Maximal post length is above my length.
                if ($self->{'post_max'} != -1
                        and $length > $self->{'post_max'}) {

                        err "413 Request entity too large: ".
                                "$length bytes on STDIN exceeds ".
                                "post_max !";

		# Get data.
                } elsif ($length) {
			read(STDIN, $data, $length) if $length > 0;
		}

		# Save data for post.
		$self->{'.query_data'} = $data if $self->{'save_query_data'};

		# Bad length of data.
		unless ($length == length $data) {
			err "500 Bad read! wanted $length, got ".
				(length $data).'.';
		}
	
	# GET/HEAD method.	
	} elsif ($method eq 'GET' || $method eq 'HEAD') {
		$data = $ENV{'QUERY_STRING'} || '';
		$self->{'.query_data'} .= $data if $self->{'save_query_data'};
	}

	# Parse params.
	if ($data) {
		$self->_parse_params($data);
	}
}

#------------------------------------------------------------------------------
sub _add_param($;$$$) {
#------------------------------------------------------------------------------
# Adding param.

	my ($self, $param, $value, $overwrite) = @_;
	return () unless defined $param and defined $value;
	@{$self->{'.parameters'}->{$param}} = () if $overwrite;
	@{$self->{'.parameters'}->{$param}} = () 
		unless exists $self->{'.parameters'}->{$param};
	my @values = ref $value eq 'ARRAY' ? @{$value} : ($value);
	foreach my $value (@values) {
		push @{$self->{'.parameters'}->{$param}}, $value;
	}	
}

#------------------------------------------------------------------------------
sub _parse_params($;$) {
#------------------------------------------------------------------------------
# Parse params from data.

	my ($self, $data) = @_;
	return () unless defined $data;	

	# Parse params.
	my @pairs = split(/&/, $data);
	foreach my $pair (@pairs) {
		my ($param, $value) = split('=', $pair);
		next unless defined $param;
		$value = '' unless defined $value;
		$self->_add_param($self->_uri_unescape($param),
			$self->_uri_unescape($value));
	}
}

#------------------------------------------------------------------------------
sub _parse_multipart($) {
#------------------------------------------------------------------------------
# Parse multipart data.

	my $self = shift;
	my ($boundary) = $ENV{'CONTENT_TYPE'} =~ /boundary=\"?([^\";,]+)\"?/;
	unless ($boundary) {
		err '400 No boundary supplied for multipart/form-data.';
	}

	# BUG: IE 3.01 on the Macintosh uses just the boundary, forgetting
	# the --
	$boundary = '--'.$boundary
		unless $ENV{'HTTP_USER_AGENT'} =~ m/MSIE\s+3\.0[12];\s*Mac/i;

	$boundary = quotemeta $boundary;
	my $got_data_length = 0;
	my $data = '';
	my $read;
	my $CRLF = $self->_crlf;
	
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

#------------------------------------------------------------------------------
sub _save_tmpfile($$$$$) {
#------------------------------------------------------------------------------
# Save file from multiform.

	my ($self, $boundary, $filename, $got_data_length, $data) = @_;
	my $fh;
	my $CRLF = $self->_crlf;
	my $file_size = 0;

	if ($self->{'disable_upload'}) {
		err '405 Not Allowed - File uploads are disabled.';
	} elsif ($filename) {
		eval { require IO::File };
		err "500 IO::File is not available $@." if $@;
		$fh = new_tmpfile IO::File;
		err "500 IO::File can't create new temp_file." unless $fh;
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

		# BUG: Fixed hanging bug if browser terminates upload part way.
		unless ($data) {
			undef $fh;
			err '400 Malformed multipart, no terminating '.
				'boundary.';
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

#------------------------------------------------------------------------------
sub _crlf($;$) {
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

#------------------------------------------------------------------------------
sub _uri_escape($$) {
#------------------------------------------------------------------------------
# Escapes uri.

	my ($self, $string) = @_;
	$string = uri_escape($string);
	$string =~ s/\ /\+/g;
	return $string;
}

#------------------------------------------------------------------------------
sub _uri_unescape($$) {
#------------------------------------------------------------------------------
# Unescapes uri.

	my ($self, $string) = @_;
	$string =~ s/\+/\ /g;
	return uri_unescape($string);
}

1;

=pod

=head1 NAME 

 CGI::Pure - TODO

=head1 SYNOPSIS

 TODO

=head1 DESCRIPTION

 TODO

=head1 SUBROUTINES

=over 4

=item B<new()>

 TODO

=item B<param()>

 TODO

=item B<append_param()>

 TODO

=item B<delete_param()>

 TODO

=item B<delete_all_params()>

 TODO

=item B<query_string()>

 TODO

=item B<upload()>

 TODO

=item B<upload_info()>

 TODO

=item B<query_data()>

 TODO

=back

=head1 EXAMPLE

 TODO

=head1 REQUIREMENTS

 L<Error::Simple::Multiple>
 L<URI::Escape>

=head1 AUTHOR

 Michal Spacek L<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
