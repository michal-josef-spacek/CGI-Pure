package SCGI::ModPerl;
# $Id: ModPerl.pm,v 1.2 2004-08-28 11:33:15 skim Exp $
# Version SCGI for mod_perl.

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

#------------------------------------------------------------------------------
sub _initialize_mod_perl {
#------------------------------------------------------------------------------
# Initialization for mod_perl.
# XXX From CGI::Simple.

        my ($self, $init) = @_;

	# TODO Why?
        eval "require mod_perl";

	# If mod_perl right?
        if (defined $mod_perl::VERSION) {

		# Apache request.
                my $r = Apache->request();

		# mod_perl version 2.
                if ($mod_perl::VERSION >= 1.99) {

			# Version.
                        $self->{'.mod_perl'} = 2;

			# Required Apache modules.
                        require Apache::RequestRec;
                        require Apache::RequestUtil;
                        require APR::Pool;

                        if (defined $r) {
                                $r->subprocess_env()
                                        unless exists $ENV{'REQUEST_METHOD'};

				# TODO CGI::Simple doesn't exist.
                                $r->pool->cleanup_register(
                                        \&CGI::Simple::_initialize_globals);
                        }

		# mod_perl version 1.
                } else {

			# Version.
                        $self->{'.mod_perl'} = 1;

			# Required Apache modules.
                        require Apache;

			# TODO CGI::Simple doesn't exist.
                        $r->register_cleanup(
                                \&CGI::Simple::_initialize_globals)
                                if defined $r;
                }
        }
}
# END of _initialize_mod_perl().

#------------------------------------------------------------------------------
sub _mod_perl {
#------------------------------------------------------------------------------
# Is there mod_perl?
# XXX From CGI::Simple.

        return (exists $ENV{'MOD_PERL'}
                || ($ENV{'GATEWAY_INTERFACE'}
                && $ENV{'GATEWAY_INTERFACE'} =~ m{^CGI-Perl/}));
}
# END of _mod_perl().

1;
