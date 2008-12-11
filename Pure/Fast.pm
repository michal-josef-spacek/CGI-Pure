#------------------------------------------------------------------------------
package CGI::Pure::Fast;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(CGI::Pure);
use strict;
use warnings;

# Modules.
use FCGI;
use Readonly;

# Constants.
Readonly::Scalar my $FCGI_LISTEN_QUEUE_DEFAULT => 100;

# Version.
our $VERSION = 0.02;

# External request.
our $EXT_REQUEST;

# Workaround for known bug in libfcgi.
while (each %ENV) { }

# If ENV{'FCGI_SOCKET_PATH'} is specified, we maintain a FCGI Request handle
# in this package variable.
BEGIN {

	# If ENV{FCGI_SOCKET_PATH} is given, explicitly open the socket,
	# and keep the request handle around from which to call Accept().
	if ($ENV{'FCGI_SOCKET_PATH'}) {
		my $path = $ENV{'FCGI_SOCKET_PATH'};
		my $backlog = $ENV{'FCGI_LISTEN_QUEUE'}
			|| $FCGI_LISTEN_QUEUE_DEFAULT;
		my $socket  = FCGI::OpenSocket($path, $backlog);
		$EXT_REQUEST = FCGI::Request(\*STDIN, \*STDOUT, \*STDERR,
			\%ENV, $socket, 1);
	}
}

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# New is slightly different in that it calls FCGI's accept() method.

	my ($class, %params) = @_;
	if (! exists $params{'init'}) {
		if ($EXT_REQUEST) {
			return if $EXT_REQUEST->Accept < 0;
		} else {
			return if FCGI::accept < 0;
		}
	}
	my $self = $class->SUPER::new(%params);
	return $self;
}

1;
