#------------------------------------------------------------------------------
package CGI::Pure::ModPerl;
#------------------------------------------------------------------------------
# $Id: Debug.pm,v 1.4 2005-01-07 21:51:22 skim Exp $
# Version with debug.

# Modules.
use CGI::Pure;

# Global variables.
use vars qw($VERSION);

# Version.
$VERSION = '1.0';

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
