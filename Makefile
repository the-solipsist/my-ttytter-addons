test-ttytter-version:
	echo '/r' | ./bin/ttytter -vcheck  | grep "your version of TTYtter is up to date"
	echo '/r' | ./bin/beta -vcheck  | grep "this is the most current beta"
test-fsearch: 
	echo "/fsearch reuteras" | ./bin/ttytter -exts=friend_search_oauth.pl -ssl -simplestart | grep "Screen name: reuteras. Name: Peter Reuterås"
	echo "/fsearch reuteras" | ./bin/beta -exts=friend_search_oauth.pl -ssl -simplestart | grep "Screen name: reuteras. Name: Peter Reuterås"
test-limit:
	echo "/limit" | ./bin/ttytter -exts=rate_limit_oauth.pl -ssl -simplestart | egrep "Remaining hits [0-9]{3}"
	echo "/limit" | ./bin/beta -exts=rate_limit_oauth.pl -ssl -simplestart | egrep "Remaining hits [0-9]{3}"
test-later:
	echo "/later c9 test hudson-test" | ./bin/ttytter -exts=later.pl -ssl -simplestart | grep "Added to delicious.com"
	curl -s -u `cat ~/.delicious` https://api.del.icio.us/v1/posts/delete?url=`cat hudson-ttytter-later-test`
	rm -f hudson-ttytter-later-test
	echo "/later c9 test hudson-test" | ./bin/beta -exts=later.pl -ssl -simplestart | grep "Added to delicious.com"
	curl -s -u `cat ~/.delicious` https://api.del.icio.us/v1/posts/delete?url=`cat hudson-ttytter-later-test`
	rm -f hudson-ttytter-later-test
	