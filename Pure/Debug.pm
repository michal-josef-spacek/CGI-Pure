package SCGI::ModPerl;
# $Id: Debug.pm,v 1.1 2004-09-08 17:31:49 skim Exp $
# Version with debug.

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
