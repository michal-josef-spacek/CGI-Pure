package SCGI;
# $Id: Pure.pm,v 1.3 2004-08-28 11:33:14 skim Exp $

# Modules.
use strict;

# Global variables.
use vars qw($VERSION);

# Version.
$VERSION = '0.1';

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
