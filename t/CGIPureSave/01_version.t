# $Id: 01_version.t,v 1.2 2005-05-19 16:36:01 skim Exp $

print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.1');
