package SCGI::Buggy;
# $Id: Buggy.pm,v 1.3 2004-08-28 11:33:15 skim Exp $
# Version SCGI for buggy servers/clients.

# Modules.
use strict;
use SCGI;

# Global variables.
use vars qw($VERSION);

# Version.
$VERSION = '0.1';

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
