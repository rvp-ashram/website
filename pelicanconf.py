#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'VigneshKumar'
SITENAME = 'Sri Ramana Vidya Peedam'
SITEURL = ''

PATH = 'content'
TIMEZONE = 'Asia/Kolkata'
DEFAULT_LANG = 'English'

# Pagination Enabled
PAGINATED_DIRECT_TEMPLATES = ('categories', 'archives')

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Registration', 'http://getpelican.com/'),
         ('Contribution', 'http://python.org/'),
         ('Gallery', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

#Backdrop Theme
SITESUBTITLE = u'A place for holistic living and self inquiry'
PROFILE_IMAGE = '../images/rvp_logo.png'
#FAVICON =
BACKDROP_IMAGE = '../images/background.jpg'
SITE_DESCRIPTION = u'The ashram is founded on two core principles - Health &  Wholistic Living & Self-Enquiry'
#DISQUS_URL = 
EMAIL = 'vigneshkumarb@bravetux.com'
YEAR = 2018
#TAG_CLOUD_MAX_ITEMS =
#LICENSE =
#BLOGKEYWORDS=
TWITTER_USERNAME = 'jakevdp'
GITHUB_USERNAME = 'jakevdp'
