#------------------------------------------------------------------------------
package CGI::Pure::Fast;
#------------------------------------------------------------------------------

# Pragmas.
use strict;

# Modules.
use CGI::Pure;
use FCGI;

# Inheritance.
our @ISA = qw(CGI::Pure);

# Version.
our $VERSION = 0.02;

# Global variables.
use vars qw($Ext_Request);

# Workaround for known bug in libfcgi.
while ((my $ignore) = each %ENV) { }

# If ENV{'FCGI_SOCKET_PATH'} is specified, we maintain a FCGI Request handle
# in this package variable.
BEGIN {

	# If ENV{FCGI_SOCKET_PATH} is given, explicitly open the socket,
	# and keep the request handle around from which to call Accept().
	if ($ENV{'FCGI_SOCKET_PATH'}) {
		my $path = $ENV{'FCGI_SOCKET_PATH'};
		my $backlog = $ENV{'FCGI_LISTEN_QUEUE'} || 100;
		my $socket  = FCGI::OpenSocket($path, $backlog);
		$Ext_Request = FCGI::Request(\*STDIN, \*STDOUT, \*STDERR, 
			\%ENV, $socket, 1);
	}
}

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# New is slightly different in that it calls FCGI's accept() method.

	my ($class, %params) = @_;
	unless (exists $params{'init'}) {
		if ($Ext_Request) {
			return undef unless $Ext_Request->Accept >= 0;
		} else {
			return undef unless FCGI::accept >= 0;
		}
	}
	return $class = $class->SUPER::new(%params);
}

1;
