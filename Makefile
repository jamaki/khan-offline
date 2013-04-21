all: fetch mp4_to_webm DVDs
	true

fetch: fetch_firefox fetch_video fetch_ck12
	true

fetch_firefox:
	cd KhanAcademyOffline; ls | grep -E 'Firefox.*exe' || wget 'ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/win32/en-GB/Firefox*.exe'
	cd KhanAcademyOffline; ls | grep -E 'Firefox.*dmg' || wget 'ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/mac/en-GB/Firefox*.dmg'
	echo Fix the links in about.html

fetch_video:
	bin/fetch_webm dsFQ9kM1qDs.mp4; cp dsFQ9kM1qDs.webm KhanAcademyOffline/khan_academy_overview.webm
	parallel -j10 'bin/fetch_webm {} && echo -n .' ::: KhanAcademyOffline/*/videos/*

fetch_ck12: KhanAcademyOffline/ck12/ck12_algebra1.pdf
	true

KhanAcademyOffline/ck12/ck12_algebra1.pdf:
	cd KhanAcademyOffline/ck12; wget http://rachel.worldpossible.org/ck12/ck12_algebra1.pdf

mp4_to_webm:
	bin/replace_mp4_with_webm

DVDs:
	seq 5 | parallel mkdir -p DVD{}
	echo > DVD1/This_is_DVD1 '/(arithmetic|pre_algebra|algebra|devmath|algebra_we|ck12|cst_algebra_1|cst_algebra_2)/'
	echo > DVD2/This_is_DVD2 '/(geometry|cst_geometry|trigonometry|precalculus|calculus)/'
	echo > DVD3/This_is_DVD3 '/(linear_algebra|differential_equations|probability|statistics)/'
	echo > DVD4/This_is_DVD4 '/(physics|chemistry|organic_chemistry)/'
	echo > DVD5/This_is_DVD5 '/(cosmology|biology)/'
	parallel -j0 cp -rl KhanAcademyOffline ::: DVD*
	parallel "find {} -name '*.webm' -o -name '*.pdf' | grep -vE -f {}/This_is_{}" ::: DVD* | parallel -X rm

clean_DVDs:
	rm -rf DVD*

clean:
	rm -rf DVD*
	rm -f -- *.webm.part Firefox* KhanAcademyOffline/Firefox
	find . -name '*.webm' | parallel -X rm --
	rm -f KhanAcademyOffline/ck12/ck12_algebra1.pdf
