# $Id: 01_version.t,v 1.3 2005-08-09 08:32:16 skim Exp $

print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.01');
