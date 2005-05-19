# $Id: 01_version.t,v 1.4 2005-05-19 16:35:58 skim Exp $

print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.1');
