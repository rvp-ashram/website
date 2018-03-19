# Sri Ramana Vidya Peedam Ashram Website

[![Build Status](https://travis-ci.org/Chennaipy/website.svg?branch=master)](https://travis-ci.org/Chennaipy/website)

This is the repo for the Chennai Python User Group's website
[http://www.sriramanavidyapeedam.org](http://www.sriramanavidyapeedam.org). The site is built
using Pelican, a static site generator, powered by Python. The
site's theme is based on [Backdrop Pelican Theme](https://github.com/getpelican/pelican-themes/tree/master/backdrop).

## Find us

* [Meetup.com](http://www.meetup.com/sriramanavidyapeedam/)
* [Mailing list](TBD)
* [Twitter](http://twitter.com/sriramanavidyapeedam)

## Setup for local development

* Fork repo

  [Fork](https://github.com/rvp-ashram/website/fork) the repository to your account
so that you have your copy of the website.

* Clone repo

        $ git clone --recursive git@github.com:<your-username>/website.git rvp-ashram-website

  This will clone the repository on to your system and clone the submodules inside
it as well recursively. Additionally, the folder to which it will be cloned to
is called `rvp-ashram-website`.

* Set up a virtual env in that folder and activate it

        $ cd <repo>
        $ virtualenv env
        $ source env/bin/activate

* Install the requirements using `pip` from inside the virtual environment

        (env)$ pip install -r requirements.txt

* Start the server

        make devserver

* Visit local site

  Open up your web browser and point it to [http://localhost:8000](http://localhost:8000) to see the site
running locally. Yay!

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)