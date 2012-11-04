# Add a command to add tweet to delicious for storage or later
# viewing from GUI browser
#

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
