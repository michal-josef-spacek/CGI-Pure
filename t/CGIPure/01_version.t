# $Id: 01_version.t,v 1.6 2008-06-22 11:35:22 skim Exp $

print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.02');
