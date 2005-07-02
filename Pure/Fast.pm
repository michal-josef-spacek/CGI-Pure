#------------------------------------------------------------------------------
package CGI::Pure::Fast;
#------------------------------------------------------------------------------
# $Id: Fast.pm,v 1.7 2005-07-02 16:16:48 skim Exp $

# Pragmas.
use strict;

# Modules.
use CGI::Pure;
use FCGI;

# Inheritance.
use vars qw(@ISA);
@ISA = ('CGI::Pure');

# Version.
our $VERSION = 0.1;

# Global variables.
use vars qw($Ext_Request);

# Workaround for known bug in libfcgi.
while (($ignore) = each %ENV) { }

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

	my ($self, $initializer, @param) = @_;
	unless (defined $initializer) {
		if ($Ext_Request) {
			return undef unless $Ext_Request->Accept() >= 0;
		} else {
			return undef unless FCGI::accept() >= 0;
		}
	}
	return $self = $self->SUPER::new($initializer, @param);
}

1;
