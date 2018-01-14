.DEFAULT_GOAL := fail2ban-ng

F2BDIR = fail2ban-ng/fail2ban
F2BREPO = https://github.com/mini2inz/fail2ban.git
F2BBRANCH = nextgen
F2BCLONEARG = --depth 1
F2BGIT = git -C $(F2BDIR)

.PHONY: fail2ban-ng ssh all clean f2b-ng-clone f2b-ng-docker run runssh sshclient fullreset


# clone or update repository used to build image
f2b-ng-clone: 
	if [ -d $(F2BDIR)/.git ]; then \
		$(F2BGIT) remote set-branches --add origin '$(F2BBRANCH)'; \
		$(F2BGIT) checkout $(F2BBRANCH); \
		$(F2BGIT) pull; \
	else \
		git clone -b $(F2BBRANCH) $(F2BCLONEARG) $(F2BREPO) $(F2BDIR); \
	fi

# build fail2ban docker image
f2b-ng-docker: f2b-ng-docker-base f2b-ng-docker-conf

F2BIMG = fail2ban-ng
F2BCONF = empty
JAILCONF = sshd
f2b-ng-docker-base: fail2ban-ng/f2bbase.Dockerfile
	docker build --rm -t $(F2BIMG) -f fail2ban-ng/f2bbase.Dockerfile fail2ban-ng/

F2BIMG_C = fail2ban-ng2
HOSTS = hosts
BUILDARGS = --build-arg F2BCONF=$(F2BCONF) --build-arg JAILCONF=$(JAILCONF) --build-arg F2BIMG=$(F2BIMG) --build-arg HOSTS=$(HOSTS)
f2b-ng-docker-conf: fail2ban-ng/f2bconf.Dockerfile
	docker build --rm -t $(F2BIMG_C) $(BUILDARGS) -f fail2ban-ng/f2bconf.Dockerfile fail2ban-ng/

# clone repo and build docker image
fail2ban-ng: f2b-ng-clone f2b-ng-docker

# clean repo
clean:
	rm -rf $(F2BDIR)

CNTNR = $(F2BIMG)
SSHPORT = 2222
CNTNRSSHARGS = -d --cap-add=NET_ADMIN --cap-add=NET_RAW --cap-add=SYS_PTRACE
SSHCLIMG = sshclient
CNTNR2 = $(SSHCLIMG)

# run fail2ban image in container - not recommended
run:
	docker run -ti --name $(CNTNR) $(F2BIMG):latest /sbin/my_init -- bash -l

# run fail2ban with ssh server in detatched container - recommended
runssh:
	docker run $(CNTNRSSHARGS) --name $(CNTNR) -p 127.0.0.1:$(SSHPORT):22 $(F2BIMG):latest 

# build docker image with ssh client
sshclient:
	docker build --rm -t $(SSHCLIMG) sshclient/

# run ssh client in container
runsshcl:
	docker run -ti --name $(CNTNR2) $(SSHCLIMG):latest bash

cleandocker:
	docker stop $(CNTNR)
	docker rm $(CNTNR)

DEVRELOAD = cleandocker f2b-ng-docker runssh

# default: stop and remove container, build new image, run it in a container 
# params: 
# - cleandocker: CNTNR - container to stop and remove
# - f2b-ng-docker: F2BIMG - docker image name
# - runssh: runs CNTNR using F2BIMG
devreload: $(DEVRELOAD)


BOTIMG = sshbot
# build ssh bot image
sshbotimg: sshbot/Dockerfile sshbot/bot.sh
	docker build --rm -t $(BOTIMG) sshbot/
