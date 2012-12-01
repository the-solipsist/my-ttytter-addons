# Command to check the current rate limit status
#
# Copyright (C) 2012 Peter Reuterås
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.                                                                                                                            
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

