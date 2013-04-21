fetch_firefox:
	cd ..; wget 'ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/win32/en-GB/Firefox*.exe'
	cd ..; wget 'ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/mac/en-GB/Firefox*.dmg'
	echo Fix the links in about.html

fetch_video:
	cd ..; tools/fetch_webm dsFQ9kM1qDs.mp4; cp dsFQ9kM1qDs.webm khan_academy_overview.webm
	cd ..; parallel -j5 tools/fetch_webm ::: */videos/*

mp4_to_webm:
	cd ..; tools/replace_mp4_with_webm

clean:
	cd ..; rm *.webm.part Firefox*
	find .. -name '*.webm' | parallel -X rm
