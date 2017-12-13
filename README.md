
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

BOTIMG = sshbot
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

## Botnet

### Docker image
Just run `make sshbotimg`. You can change the image name (`BOTIMG`).

### Configuration
Botnet can be configured in `botnet.config`. In each line you can specify number of bots that will try to ssh into specified host on given port. 

Example:
```
5 172.17.0.2 1234
```
5 bots will try to connect server with an IP 172.17.0.2 that listens on port 1234. Default credentials are root/passwordddd.


### Start botnet
```
$ ./botnet.py
```

If script is not executable use `chmod +x`.

This will start `n` bots in containers named `sshbot<id>` where id is in `[1,2,...,n]`. Id range can be shifted with `--id` parameter passed to `botnet.py` to spawn additional bots.

Parameters:
```
-b, --bots, type=int - number of containers with bots to stop, default=0
-i, --image, type=str, default=sshbot:latest
-c, --container, type=str, default=sshbot
--bash, type=bool - choose bot script, default=True
--id, type=int, default=0
```

### Stop botnet
```
$ ./botnet.py -b 5
```
You can pass an argument with container name if it's not default `sshbot`.
