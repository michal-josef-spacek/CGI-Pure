#------------------------------------------------------------------------------
package SCGI::Buggy;
#------------------------------------------------------------------------------
# $Id: Buggy.pm,v 1.5 2004-09-28 18:08:18 skim Exp $
# Version SCGI for buggy servers/clients.

# Modules.
use strict;
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
