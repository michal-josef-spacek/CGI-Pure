#------------------------------------------------------------------------------
package CGI::Pure::ModPerl;
#------------------------------------------------------------------------------
# $Id: Debug.pm,v 1.6 2005-07-02 16:16:48 skim Exp $
# Version with debug.

# Pragmas.
use strict;

# Modules.
use CGI::Pure;

# Version.
our $VERSION = 0.1;

# Inheritance.
use vars qw(@ISA);
@ISA = ('CGI::Pure');

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = $class->SUPER::new(@_);
	return bless $self, $class;
}

1;
