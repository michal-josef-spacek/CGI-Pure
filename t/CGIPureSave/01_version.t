# $Id: 01_version.t,v 1.1 2004-09-28 21:02:39 skim Exp $

print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '1.0');
