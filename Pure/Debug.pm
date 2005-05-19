#------------------------------------------------------------------------------
package CGI::Pure::ModPerl;
#------------------------------------------------------------------------------
# $Id: Debug.pm,v 1.5 2005-05-19 16:16:04 skim Exp $
# Version with debug.

# Modules.
use CGI::Pure;

# Version.
ouor $VERSION = 0.1;

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
# END of new().

1;
