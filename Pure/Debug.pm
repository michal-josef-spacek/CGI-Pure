#------------------------------------------------------------------------------
package SCGI::ModPerl;
#------------------------------------------------------------------------------
# $Id: Debug.pm,v 1.3 2004-10-02 12:56:13 skim Exp $
# Version with debug.

# Modules.
use SCGI;

# Global variables.
use vars qw($VERSION);

# Version.
$VERSION = '1.0';

# Inheritance.
use vars qw(@ISA);
@ISA = ('SCGI');

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
