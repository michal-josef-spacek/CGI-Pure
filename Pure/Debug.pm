#------------------------------------------------------------------------------
package SCGI::ModPerl;
#------------------------------------------------------------------------------
# $Id: Debug.pm,v 1.2 2004-09-08 22:25:54 skim Exp $
# Version with debug.

# Modules.
use strict;
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
