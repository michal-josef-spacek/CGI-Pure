package SCGI::Buggy;
# $Id: Buggy.pm,v 1.1 2004-08-28 11:20:51 skim Exp $

# Modules.
use strict;
use SCGI;

# TODO
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

sub pokus {
	my $self = shift;
	print "SCGI::Buggy\n";
	print $self->{'pokus'};
	print "\n";
}

1;
