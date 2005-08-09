# $Id: 01_version.t,v 1.5 2005-08-09 08:32:23 skim Exp $

print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.01');
