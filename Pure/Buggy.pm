#------------------------------------------------------------------------------
package CGI::Pure::Buggy;
#------------------------------------------------------------------------------
# $Id: Buggy.pm,v 1.9 2005-07-02 16:16:47 skim Exp $
# Version CGI::Pure for buggy servers/clients.

# Pragmas.
use strict;

# Modules.
use CGI::Pure;

# Version.
our $VERSION = 0.1;

# Inheritance.
use vars qw(@ISA);
@ISA = ('CGI::Pure');

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = $class->SUPER::new(@_);
	return bless $self, $class;
}

1;
