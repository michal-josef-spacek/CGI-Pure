# $Id: 01_version.t,v 1.2 2004-09-28 17:15:09 skim Exp $

print "Testing: version.\n" if $debug;
ok($SCGI::VERSION, '1.0');
