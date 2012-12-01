# Add a command to add tweet to delicious for storage or later
# viewing from GUI browser
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

    if ($command =~ m#^/later ([^ ]+) ([^ ]+)( (.+))?#) {
        my $tweet_id=$1;
        my $desc=$2;
        my $testing=$4;
        my $tweet=&get_tweet($tweet_id);
        my $content;
        if (!$tweet->{'id_str'}) {
            print $stdout "-- sorry, no such tweet (yet?).\n";
            return 1;
        }
        chop( my $del_pass=`cat ~/.delicious`);
        my $add_url="https://twitter.com/$tweet->{'user'}->{'screen_name'}/statuses/$tweet->{'id'}";
        my $delicious_url="https://api.del.icio.us/v1/posts/add?url=" .
            $add_url . "&tags=\@ttytter_added\@&shared=no&description=$desc";
        if ($testing == "hudson-test"){
            $content = `curl -k -s -u \"$del_pass\" \"$delicious_url\"`;
        }else{ 
            $content = `curl -s -u \"$del_pass\" \"$delicious_url\"`;
        }
        if ($content =~ m!<result code="done" ?/>!){
            print "Added to delicious.com\n";
            if ($testing == "hudson-test"){
                `echo "$add_url" > hudson-ttytter-later-test`;
            }
        }else{ 
            print "Something went wrong, not added. See response:\n" if $content;
            print $content;
            print "Something went wrong, probably because of an SSL problem.\n" if not $content;
        }
        return 1;
    }
    return 0;
};
