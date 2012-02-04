# Command to check the current rate limit status
#
# Copyright 2012 Peter Reuterås
#
# License: GPL v2
#
#

$addaction = sub {
	my $command = shift;

	if ($command =~ m#^/report ([^ ]+)#) {
        my $tweet=&get_tweet($1);
        if (!$tweet->{'user'}) {
            print $stdout "-- sorry, no such tweet (yet?).\n";
            return 1;
	    }
        $user=$tweet->{'user'};
        $sender=$user->{'screen_name'};
	    $reporturl ||= "${apibase}/report_spam.json";
		$result = &postjson("$reporturl", "screen_name=$sender");
		if (defined($result) && ref($result) eq 'HASH') {
		    print "Sender $sender reported.\n";
			return 1;
      }
	}
	return 0;
};

