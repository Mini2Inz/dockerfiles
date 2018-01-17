FROM alpine:3.7

RUN apk add --no-cache openssh-client sshpass bash

WORKDIR /bot
COPY bot.sh .
COPY hosts .
RUN chmod +x bot.sh
CMD ["/bin/bash", "./bot.sh"]