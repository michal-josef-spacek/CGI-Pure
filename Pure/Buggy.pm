#------------------------------------------------------------------------------
package CGI::Pure::Buggy;
#------------------------------------------------------------------------------
# $Id: Buggy.pm,v 1.7 2005-01-07 21:51:22 skim Exp $
# Version CGI::Pure for buggy servers/clients.

# Modules.
use CGI::Pure;

# Global variables.
use vars qw($VERSION);

# Version.
$CGI::Pure::Buggy::VERSION = '1.0';

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
