#------------------------------------------------------------------------------
package SCGI::Buggy;
#------------------------------------------------------------------------------
# $Id: Buggy.pm,v 1.6 2004-10-02 12:56:13 skim Exp $
# Version SCGI for buggy servers/clients.

# Modules.
use SCGI;

# Global variables.
use vars qw($VERSION);

# Version.
$SCGI::Buggy::VERSION = '1.0';

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
