package SCGI;
# $Id: Pure.pm,v 1.1 2004-08-28 11:20:50 skim Exp $

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

sub pokus {
	my $self = shift;
	print "SCGI\n";
	print $self->{'pokus'};
	print "\n";
}

1;
