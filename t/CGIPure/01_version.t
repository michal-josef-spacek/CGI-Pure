print "Testing: version.\n" if $debug;
ok(eval('$'.$class.'::VERSION'), '0.02');
