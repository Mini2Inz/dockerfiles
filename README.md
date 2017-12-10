
## Building and using fail2ban-ng docker image

While using `make` you can specify which branch you want to checkout and how the image will be named.

Example:
```
$ make F2BBRANCH=nextgen_dbext F2BIMG=f2b-dbext
```


List of variables with default values:
```
F2BDIR = fail2ban-ng/fail2ban
F2BREPO = https://github.com/mini2inz/fail2ban.git
F2BBRANCH = nextgen
F2BIMG = fail2ban-ng
F2BCLONEARG = --depth 1
F2BGIT = git -C $(F2BDIR)

CNTNR = $(F2BIMG) 
SSHPORT = 2222
CNTNRSSHARGS = -d --cap-add=NET_ADMIN --cap-add=NET_RAW
```

### Getting into docker container

```
$ make runssh CNTNR=f2b F2BIMG=fail2ban-ng SSHPORT=2222
$ ssh root@localhost -p 2222
```

