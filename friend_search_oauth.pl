# Command to search among the users friends
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

# Every 100  friends will decreate your rate limit with one

$addaction = sub {
	my $command = shift;

	if ($command =~ s!^/fsearch !! && length($command)) {
		my $content="none";
		my $next_cursor=-1;
		my $friend_url="http://api.twitter.com/1/statuses/friends.json";
		if(defined $store->{'fsearch_content'}) {
			$content = $store->{'fsearch_content'};
		} else {
			while ($next_cursor ne "done"){
				$result = &grabjson("$friend_url?cursor=$next_cursor");
				if (defined($result) && ref($result->{'users'}) eq 'ARRAY') {
		      	my $i;
					foreach $i (@{ $result->{'users'} }) {
						$store->{'fsearch_content'}.=&descape("Screen name: $i->{'screen_name'}. Name: $i->{'name'}\n");
					}
				} 
				if($result->{'next_cursor'} =~ /([0-9]{2,})/){
					$next_cursor=$1;
				} else {
					$next_cursor="done";
				}
				print "Retriving the next 100 friends, id ".$next_cursor.".\n" if $next_cursor ne "done";
				print "Retrived all friends.\n" if $next_cursor eq "done";
			}
			$content=$store->{'fsearch_content'};
		}
		my @lines = split /^/, $content;
		for (my $nr=0; $nr < @lines; $nr++){
			if($lines[$nr] =~ m/$command/i){
				print $lines[$nr];
			}
		}
		return 1;
	} elsif ($command =~ s!^/fsearch!! ){
		print "Need a argument.\n";
		return 1;
	}

	return 0;
};

