# $Id: 01_version.t,v 1.3 2004-09-28 21:02:53 skim Exp $

print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '1.0');
