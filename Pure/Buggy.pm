package SCGI::Buggy;
# $Id: Buggy.pm,v 1.2 2004-08-28 11:23:12 skim Exp $

# Modules.
use strict;
use SCGI;

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
