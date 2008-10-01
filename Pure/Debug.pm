#------------------------------------------------------------------------------
package CGI::Pure::ModPerl;
#------------------------------------------------------------------------------
# Version with debug.

# Pragmas.
use strict;

# Modules.
use CGI::Pure;

# Version.
our $VERSION = 0.01;

# Inheritance.
our @ISA = ('CGI::Pure');

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = $class->SUPER::new(@_);
	return bless $self, $class;
}

1;
