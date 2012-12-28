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

	if ($command =~ s#^/limit##) {
		my $result = &grabjson("$rlurl");
		if (defined($result) && ref($result) eq 'HASH') {
		    print "Limit period is 15 min, see https://dev.twitter.com/docs/api/1.1/get/application/rate_limit_status for more info.\n";
		    foreach $status ('/statuses/user_timeline', '/statuses/mentions_timeline', '/statuses/home_timeline', '/statuses/show/:id', '/statuses/retweets/:id'){
			    my $reset_time_in_seconds=$result->{'resources'}{'statuses'}{$status}{reset};
			    my $reset_limit=$result->{'resources'}{'statuses'}{$status}{limit};
			    my $reset_remaining=$result->{'resources'}{'statuses'}{$status}{remaining};
			    (my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdst)=localtime($reset_time_in_seconds);
    			my $reset_time = sprintf "%4d-%02d-%02d %02d:%02d:%02d", $year+1900,$mon+1, $mday, $hour, $min, $sec;
			    print "Remaining hits for ".$status. " is ".$reset_remaining. "/".$reset_limit.", resets at ". $reset_time.".\n";
    		}
			return 1;
      }
	}
	return 0;
};

