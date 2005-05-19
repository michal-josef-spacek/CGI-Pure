#------------------------------------------------------------------------------
package CGI::Pure::Buggy;
#------------------------------------------------------------------------------
# $Id: Buggy.pm,v 1.8 2005-05-19 16:16:03 skim Exp $
# Version CGI::Pure for buggy servers/clients.

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
# END of new().

1;
