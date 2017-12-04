## Build all
```
$ make
```

## Building and using fail2ban-ng docker image

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
F2BCLONEARG = --depth 1

SSHIMG = sshf2b
```

### Getting into docker container

```
$ docker run -it fail2ban-ng:latest /bin/bash
```

## Building and using ssh docker image

```
$ make ssh
$ docker run -d -P --name sshf2b -p 2222:22 sshf2b:latest 
$ ssh root@localhost -p 2222 
```

To stop and remove container:
```
$ docker stop sshf2b
$ docker rm sshf2b
```
