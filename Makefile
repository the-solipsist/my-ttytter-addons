test-ttytter-version:
	echo '/r' | ./bin/ttytter -vcheck  | grep "your version of TTYtter is up to date"
test-fsearch: 
	echo "/fsearch reuteras" | ./bin/ttytter -exts=friend_search_oauth.pl -ssl -simplestart | grep "Name: Peter Reuter"
test-limit:
	echo "/limit" | ./bin/ttytter -exts=rate_limit_oauth.pl -ssl -simplestart | egrep "rate_limit_context"
test-later:
	echo "/later c9 test hudson-test" | ./bin/ttytter -exts=later.pl -ssl -simplestart | egrep "(done|item alread)"
	curl -s -k -u `cat ~/.delicious` https://api.del.icio.us/v1/posts/delete?url=`cat hudson-ttytter-later-test`
	rm -f hudson-ttytter-later-test
	
