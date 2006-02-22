# $Id: 01_version.t,v 1.1 2006-02-22 00:15:31 skim Exp $

print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.02');
