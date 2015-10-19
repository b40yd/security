#!/bin/env python

import urllib2
import re
from BeautifulSoup import BeautifulSoup

coder = 'utf-8'

patt=re.compile(r'(\w+)="(.+?)"')
page=urllib2.urlopen("http://localhost/darklink")
soup=BeautifulSoup(page, fromEncoding=coder)
page.close()

urls = [];
for a in soup.findAll('a'):
    a = a.__str__(coder)
    urls.append(dict(map(None,patt.findall(a))))

#print urls

for url in urls:
	s = url.get('style')
	st = str(s).find("display:none")
	if st >= 0:
		print(s,st,True)
