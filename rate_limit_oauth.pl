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
			my $reset_time_in_seconds=$result->{'reset_time_in_seconds'};
			(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,
				my $isdst)=localtime($reset_time_in_seconds);
			my $reset_time = sprintf "%4d-%02d-%02d %02d:%02d:%02d", 
				$year+1900,$mon+1,$mday,$hour,$min,$sec;
			print "Remaining hits ".$result->{'remaining_hits'}.", resets at ".
				$reset_time.". Hourly limit is ".$result->{'hourly_limit'}.".\n";
			return 1;
      }
	}
	return 0;
};

