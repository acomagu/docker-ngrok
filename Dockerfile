FROM alpine:latest
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk && \
    apk add glibc-2.29-r0.apk
RUN adduser -h /home/ngrok -D -u 6737 ngrok

FROM scratch
COPY --from=0 ngrok .
COPY --from=0 /lib64 /lib64
COPY --from=0 /usr/glibc-compat /usr/glibc-compat
COPY --from=0 /etc/passwd /etc/passwd
USER ngrok
ENV USER ngrok

ENTRYPOINT ["./ngrok"]
