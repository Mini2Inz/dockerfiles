.DEFAULT_GOAL := all

F2BDIR = fail2ban-ng/fail2ban
F2BREPO = https://github.com/mini2inz/fail2ban.git
F2BBRANCH = nextgen
F2BIMG = fail2ban-ng
F2BCLONEARG = --depth 1
F2BGIT = git -C $(F2BDIR)

SSHIMG = sshf2b


f2b-ng-clone: 
	if [ -d $(F2BDIR)/.git ]; then \
		$(F2BGIT) remote set-branches --add origin '$(F2BBRANCH)'; \
		$(F2BGIT) checkout $(F2BBRANCH); \
		$(F2BGIT) pull; \
	else \
		git clone -b $(F2BBRANCH) $(F2BCLONEARG) $(F2BREPO) $(F2BDIR); \
	fi

f2b-ng-docker: fail2ban-ng/Dockerfile
	docker build --rm -t $(F2BIMG) fail2ban-ng/

fail2ban-ng: f2b-ng-clone f2b-ng-docker

ssh: ssh/Dockerfile
	docker build --rm -t $(SSHIMG) --build-arg f2bimg=$(F2BIMG) ssh/

all: fail2ban-ng ssh

CNTNR = $(F2BIMG)
SSHPORT = 2222

run:
	docker run -t -i --name $(CNTNR) $(F2BIMG):latest /sbin/my_init -- bash -l

runssh:
	docker run -d -P --name $(CNTNR) -p $(SSHPORT):22 $(F2BIMG):latest 

.PHONY: fail2ban-ng ssh all clean f2b-ng-clone f2b-ng-docker run runssh

clean:
	rm -rf $(F2BDIR)

