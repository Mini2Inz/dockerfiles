FROM alpine:3.7

RUN apk add --no-cache openssh-client sshpass

WORKDIR /bot
COPY bot.sh .
RUN chmod +x bot.sh