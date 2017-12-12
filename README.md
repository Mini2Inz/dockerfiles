
## Building and using fail2ban-ng docker image

When you build image you can specify which branch you want to checkout and how the image will be named.

Example:
```
$ make fail2ban-ng F2BBRANCH=nextgen_dbext F2BIMG=f2b-dbext
```

### Configuring Fail2ban

When using `f2b-ng-docker` you can define `F2BCONF` and `JAILCONF`. These variables correspond to folders under `config/` which contain configuration files for Fail2ban and jails respectively. They are passed down to the `Dockerfile`.

Defaults in `Makefile`: 
* `F2BCONF = debug`
* `JAILCONF = sshd`

Defaults in `Dockerfile`: 
* `F2BCONF = empty`
* `JAILCONF = sshd`

### List of variables with default values
```
.DEFAULT_GOAL := fail2ban-ng

F2BDIR = fail2ban-ng/fail2ban
F2BREPO = https://github.com/mini2inz/fail2ban.git
F2BBRANCH = nextgen
F2BIMG = fail2ban-ng
F2BCLONEARG = --depth 1
F2BGIT = git -C $(F2BDIR)

F2BCONF = debug
JAILCONF = sshd
BUILDARGS = --build-arg F2BCONF=$(F2BCONF) --build-arg JAILCONF=$(JAILCONF)

CNTNR = $(F2BIMG) 
SSHPORT = 2222
CNTNRSSHARGS = -d --cap-add=NET_ADMIN --cap-add=NET_RAW
SSHCLIMG = sshclient
CNTNR2 = $(SSHCLIMG)

DEVRELOAD = cleandocker f2b-ng-docker runssh
```

### Getting into docker container

```
$ make runssh CNTNR=f2b F2BIMG=fail2ban-ng SSHPORT=2222
$ ssh root@localhost -p 2222
```

## Stop-build-start

For our convenience there's a single command to stop currently running container, build new image and start the container again:
```
$ make devreload
``` 
`F2BIMG` will be used as image and container name if `CNTNR` was not defined.

