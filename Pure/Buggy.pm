#------------------------------------------------------------------------------
package CGI::Pure::Buggy;
#------------------------------------------------------------------------------
# Version CGI::Pure for buggy servers/clients.

# Pragmas.
use strict;

# Modules.
use CGI::Pure;

# Version.
our $VERSION = 0.01;

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
