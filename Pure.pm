package SCGI;
# $Id: Pure.pm,v 1.2 2004-08-28 11:23:10 skim Exp $

# Modules.
use strict;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = {};
	$self->{'pokus'} = 1;
	return bless $self, $class;
}
# END of new().

#------------------------------------------------------------------------------
sub DESTROY {
#------------------------------------------------------------------------------
# Destroy object.

        my $self = shift;
        undef $self;
}
# END of DESTROY().

1;
