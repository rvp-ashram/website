PY?=python3
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py
THEMECONF=$(BASEDIR)/themes/backdrop

FTP_HOST=sriramanavidyapeedam.org
FTP_USER=pelican@sriramanavidyapeedam.org
FTP_TARGET_DIR=.

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

S3_BUCKET=my_s3_bucket

CLOUDFILES_USERNAME=my_rackspace_username
CLOUDFILES_API_KEY=my_rackspace_api_key
CLOUDFILES_CONTAINER=my_cloudfiles_container

DROPBOX_DIR=~/Dropbox/Public/

GITHUB_PAGES_BRANCH=gh-pages

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          start/restart develop_server.sh    '
	@echo '   make stopserver                     stop local server                  '
	@echo '   make ssh_upload                     upload the web site via SSH        '
	@echo '   make rsync_upload                   upload the web site via rsync+ssh  '
	@echo '   make dropbox_upload                 upload the web site via Dropbox    '
	@echo '   make ftp_upload                     upload the web site via FTP        '
	@echo '   make s3_upload                      upload the web site via S3         '
	@echo '   make cf_upload                      upload the web site via Cloud Files'
	@echo '   make github                         upload the web site via gh-pages   '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -t $(THEMECONF)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -t $(THEMECONF)

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

serve-global:
ifdef SERVER
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 $(SERVER)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 0.0.0.0
endif


devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	$(BASEDIR)/develop_server.sh stop
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS) -t $(THEMECONF)

ssh_upload: publish
	scp -P $(SSH_PORT) -r $(OUTPUTDIR)/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

rsync_upload: publish
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR) --cvs-exclude

dropbox_upload: publish
	cp -r $(OUTPUTDIR)/* $(DROPBOX_DIR)

ftp_upload: publish
	lftp ftp://$(FTP_USER)@$(FTP_HOST) -e "mirror -R $(OUTPUTDIR) $(FTP_TARGET_DIR) ; quit"

ftp_direct_upload: publish
	lftp -u $(FTP_USER),$(LFTP_PASSWORD) $(FTP_HOST) -p 21 -e "set bmk:auto-sync yes; set bmk:save-passwords no; set cache:cache-empty-listings false; set cache:enable yes; set cache:expire 1h; set cache:expire-negative 1h; set cache:size 1024; set cmd:at-background ""; set cmd:at-exit ""; set cmd:at-exit-bg ""; set cmd:at-exit-fg ""; set cmd:at-finish ""; set cmd:at-queue-finish ""; set cmd:at-terminate ""; set cmd:cls-completion-default -FBa; set cmd:cls-default -F; set cmd:cls-exact-time yes; set cmd:csh-history off; set cmd:default-protocol ftp; set cmd:default-title "lftp \\h:\\w"; set cmd:fail-exit no; set cmd:interactive auto; set cmd:long-running 30; set cmd:ls-default ""; set cmd:move-background yes; set cmd:move-background-detach yes; set cmd:parallel 5; set cmd:prompt "lftp \\S\\? \\u\\@\\h:\\w> "; set cmd:queue-parallel 5; set cmd:remote-completion yes;set cmd:save-cwd-history yes; set cmd:save-rl-history yes; set cmd:set-term-status no; set cmd:show-status yes; set cmd:status-interval 0.8s; set cmd:stifle-rl-history 500; set cmd:term-status ""; set cmd:term-status/*rxvt* "\\e[11;0]\\e]2;\\T\\007\\e[11]"; set cmd:term-status/*screen* \\e_\\T\\e\\; set cmd:term-status/*xterm* "\\e[11;0]\\e]2;\\T\\007\\e[11]"; set cmd:time-style "%b %e  %Y|%b %e %H:%M";set cmd:trace no; set cmd:verbose no; set cmd:verify-host yes; set cmd:verify-path no; set cmd:verify-path-cached no; set color:dir-colors "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"; set color:use-color auto; set dns:SRV-query no; set dns:cache-enable yes; set dns:cache-expire 1h; set dns:cache-size 256; set dns:fatal-timeout 7d; set dns:max-retries 1000; set dns:order "inet6 inet"; set dns:use-fork yes; set file:charset UTF-8; set fish:auto-confirm no; set fish:charset ""; set fish:connect-program "ssh -a -x"; set fish:shell /bin/sh; set ftp:abor-max-wait 15s; set ftp:acct ""; set ftp:anon-pass lftp@; set ftp:anon-user anonymous; set ftp:auto-passive-mode yes; set ftp:auto-sync-mode "icrosoft FTP Service|MadGoat|MikroTik"; set ftp:bind-data-socket yes; set ftp:catch-size yes; set ftp:charset ""; set ftp:client lftp/4.6.0; set ftp:device-prefix no; set ftp:fix-pasv-address yes; set ftp:fxp-force no; set ftp:fxp-passive-source no; set ftp:fxp-passive-sscn yes; set ftp:home ""; set ftp:ignore-pasv-address no; set ftp:lang ""; set ftp:list-empty-ok no; set ftp:list-options ""; set ftp:netkey-allow yes; set ftp:nop-interval 120; set ftp:passive-mode 1; set ftp:port-ipv4 ""; set ftp:port-range full; set ftp:prefer-epsv no; set ftp:proxy ""; set ftp:proxy-auth-type user; set ftp:rest-list no; set ftp:rest-stor yes; set ftp:retry-530 "too many|overloaded|try (again |back )?later|is restricted to|maximum number|number of connect|only.*session.*allowed|more connection|already connected|simultaneous login"; set ftp:retry-530-anonymous "Login incorrect"; set ftp:site (nil); set ftp:site-group ""; set ftp:skey-allow yes; set ftp:skey-force no; set ftp:ssl-allow yes; set ftp:ssl-allow-anonymous no;set ftp:ssl-auth TLS; set ftp:ssl-copy-sid yes; set ftp:ssl-data-use-keys yes; set ftp:ssl-force true; set ftp:ssl-protect-data true; set ftp:ssl-protect-fxp no; set ftp:ssl-protect-list yes; set ftp:ssl-shutdown-timeout 5; set ftp:ssl-use-ccc no; set ftp:stat-interval 1; set ftp:strict-multiline off; set ftp:sync-mode yes; set ftp:sync-mode/ftp.idsoftware.com on; set ftp:sync-mode/ftp.microsoft.com on; set ftp:sync-mode/sunsolve.sun.com on; set ftp:timezone GMT; set ftp:trust-feat no; set ftp:use-abor yes; set ftp:use-allo yes; set ftp:use-feat yes; set ftp:use-fxp yes; set ftp:use-hftp yes; set ftp:use-ip-tos no; set ftp:use-mdtm off; set ftp:use-mdtm-overloaded no; set ftp:use-mlsd on; set ftp:use-pret yes; set ftp:use-quit yes; set ftp:use-site-chmod yes; set ftp:use-site-idle no; set ftp:use-site-utime yes; set ftp:use-site-utime2 yes; set ftp:use-size yes; set ftp:use-stat yes; set ftp:use-stat-for-list true; set ftp:use-telnet-iac yes; set ftp:use-tvfs auto; set ftp:use-utf8 yes; set ftp:verify-address no; set ftp:verify-port no; set ftp:waiting-150-timeout 5; set ftp:web-mode off; set ftps:initial-prot ""; set hftp:cache yes; set hftp:cache-control ""; set hftp:decode no; set hftp:proxy ""; set hftp:use-allprop no; set hftp:use-authorization yes; set hftp:use-head yes; set hftp:use-mkcol no; set hftp:use-propfind no; set hftp:use-type yes; set http:accept */*; set http:accept-charset ""; set http:accept-encoding ""; set http:accept-language ""; set http:authorization ""; set http:cache yes; set http:cache-control ""; set http:cookie ""; set http:decode yes; set http:post-content-type application/x-www-form-urlencoded; set http:proxy ""; set http:put-content-type ""; set http:put-method PUT; set http:referer ""; set http:set-cookies no;set http:use-allprop no; set http:use-mkcol yes; set http:use-propfind no; set http:user-agent lftp/4.6.0; set https:proxy ""; set mirror:dereference no; set mirror:exclude-regex "(^|/)(\\.in\\.|\\.nfs)"; set mirror:include-regex ""; set mirror:no-empty-dirs yes; set mirror:order "*.sfv *.sig *.md5* *.sum * */"; set mirror:parallel-directories yes; set mirror:parallel-transfer-count 5;  set mirror:require-source no; set mirror:set-permissions yes; set mirror:skip-noaccess no; set mirror:sort-by name; set mirror:use-pget-n 1; set module:path /usr/lib/lftp/4.6.0:/usr/lib/lftp; set net:connection-limit 0; set net:connection-takeover yes; set net:idle 3m; set net:limit-max 0; set net:limit-rate 0:0; set net:limit-total-max 0; set net:limit-total-rate 0:0; set net:max-retries 1000 set net:no-proxy ""; set net:persist-retries 0; set net:reconnect-interval-base 30; set net:reconnect-interval-max 600; set net:reconnect-interval-multiplier 1.5; set net:socket-bind-ipv4 ""; set net:socket-bind-ipv6 ""; set net:socket-buffer 0; set net:socket-maxseg 0; set net:timeout 5m; set pget:default-n 5; set pget:min-chunk-size 1M; set pget:save-status 10s; set sftp:auto-confirm no; set sftp:charset ""; set sftp:connect-program "ssh -a -x"; set sftp:max-packets-in-flight 16; set sftp:protocol-version 6; set sftp:server-program sftp; set sftp:size-read 32k; set sftp:size-write 32k; set sftp:use-full-path yes; set ssl:ca-file /etc/ssl/certs/ca-certificates.crt; set ssl:cert-file ""; set ssl:check-hostname false; set ssl:crl-file ""; set ssl:key-file ""; set ssl:use-sni yes; set ssl:verify-certificate no; set torrent:ip ""; set torrent:ipv6 ""; set torrent:max-peers 60; set torrent:port-range 6881-6889; set torrent:retracker ""; set torrent:save-metadata yes; set torrent:seed-max-time 30d; set torrent:seed-min-peers 3; set torrent:stop-on-ratio 2.0; set torrent:use-dht yes; set xfer:auto-rename no; set xfer:buffer-size 0x10000; set xfer:clobber no; set xfer:destination-directory ""; set xfer:disk-full-fatal no; set xfer:eta-period 120; set xfer:eta-terse yes; set xfer:log yes; set xfer:log-file ""; set xfer:make-backup yes; set xfer:max-log-size 1M; set xfer:max-redirections 10; set xfer:rate-period 15; set xfer:temp-file-name .in.*; set xfer:use-temp-file no; set xfer:verify yes; set xfer:verify-command /usr/share/lftp/verify-file; mirror -R $(OUTPUTDIR)/pages $(FTP_TARGET_DIR)/pages ; quit"
	#lftp -u $(FTP_USER),$(LFTP_PASSWORD) $(FTP_HOST) -p 21 -e "mirror -R $(OUTPUTDIR)/category $(FTP_TARGET_DIR)/category ; quit"
	#lftp -u $(FTP_USER),$(LFTP_PASSWORD) $(FTP_HOST) -p 21 -e "mirror -R $(OUTPUTDIR)/author $(FTP_TARGET_DIR)/author ; quit"
	#lftp -u $(FTP_USER),$(LFTP_PASSWORD) $(FTP_HOST) -p 21 -e "mirror -R $(OUTPUTDIR)/tag $(FTP_TARGET_DIR)/tag ; quit"
	

s3_upload: publish
	s3cmd sync $(OUTPUTDIR)/ s3://$(S3_BUCKET) --acl-public --delete-removed --guess-mime-type --no-mime-magic --no-preserve

cf_upload: publish
	cd $(OUTPUTDIR) && swift -v -A https://auth.api.rackspacecloud.com/v1.0 -U $(CLOUDFILES_USERNAME) -K $(CLOUDFILES_API_KEY) upload -c $(CLOUDFILES_CONTAINER) .

github: publish
	ghp-import -m "Generate Pelican site" -b $(GITHUB_PAGES_BRANCH) $(OUTPUTDIR)
	git push origin $(GITHUB_PAGES_BRANCH)

.PHONY: html help clean regenerate serve serve-global devserver stopserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github
