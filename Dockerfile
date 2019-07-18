FROM adoptopenjdk/openjdk11:x86_64-alpine-jdk-11.0.3_7

USER root

RUN apk --no-cache add ca-certificates \
	&& wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub \
	&& wget https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/0.6.0-r1/git-crypt-0.6.0-r1.apk \
	&& apk add git-crypt-0.6.0-r1.apk

RUN apk add --no-cache bash

ENV OS_CLI_VERSION v3.11.0
ENV OS_TAG 0cbc58b

RUN apk add curl && \
	curl -s -L https://github.com/openshift/origin/releases/download/${OS_CLI_VERSION}/openshift-origin-client-tools-${OS_CLI_VERSION}-${OS_TAG}-linux-64bit.tar.gz -o /tmp/oc.tar.gz && \
	tar zxvf /tmp/oc.tar.gz -C /tmp/ && \ 
	mv /tmp/openshift-origin-client-tools-${OS_CLI_VERSION}-${OS_TAG}-linux-64bit/oc /usr/bin/ && \
	rm -rf /tmp/oc.tar.gz /tmp/openshift-origin-client-tools-${OS_CLI_VERSION}-${OS_TAG}-linux-64bit/ && \
	rm -rf /root/.cache /var/cache/apk/ && \
	oc version

ADD jq-linux64 /usr/bin/jq
RUN chmod +x /usr/bin/jq

ADD phraseapp_linux_amd64 /usr/local/bin/phraseapp
RUN chmod +x /usr/local/bin/phraseapp

RUN oc version