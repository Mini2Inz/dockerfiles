# How to build fail2ban docker image

While using `make` you can specify which branch you want to checkout and how the image will be named.

Example:
```bash
$ make fail2ban-ng F2BBRANCH=dbext F2BIMG=f2b-dbext
```

`F2BIMG` is also used to build docker image with `ssh` server.

List of variables with default values:
```
F2BDIR = fail2ban-ng/fail2ban
F2BREPO = https://github.com/mini2inz/fail2ban.git
F2BBRANCH = nextgen
F2BIMG = fail2ban-ng
F2BCLONEARG = --depth 1 --no-single-branch

SSHIMG = sshf2b
```