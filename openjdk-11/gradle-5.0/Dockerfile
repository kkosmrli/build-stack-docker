FROM adoptopenjdk/openjdk11:x86_64-alpine-jdk-11.28

USER root
RUN set -o errexit -o nounset \
	&& echo "Installing build dependencies" \
	&& apk add --update nodejs npm make && rm -rf /var/cache/apk/*

RUN apk --no-cache add ca-certificates \
	&& wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub \
	&& wget https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/0.6.0-r0/git-crypt-0.6.0-r0.apk \
	&& apk add git-crypt-0.6.0-r0.apk

ADD jq-linux64 /usr/bin/jq
RUN chmod +x /usr/bin/jq

ADD phraseapp_linux_amd64 /usr/local/bin/phraseapp
RUN chmod +x /usr/local/bin/phraseapp

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.0

ARG GRADLE_DOWNLOAD_SHA256=6157ac9f3410bc63644625b3b3e9e96c963afd7910ae0697792db57813ee79a6
RUN set -o errexit -o nounset \
	&& echo "Downloading Gradle" \
	&& wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
	\
	&& echo "Adding gradle user and group" \
	&& addgroup -S -g 1000 gradle \
	&& adduser -D -S -G gradle -u 1000 -s /bin/ash gradle \
	&& mkdir /home/gradle/.gradle \
	&& chown -R gradle:gradle /home/gradle \
	\
	&& echo "Symlinking root Gradle cache to gradle Gradle cache" \
	&& ln -s /home/gradle/.gradle /root/.gradle

# Create Gradle volume
USER gradle
VOLUME "/home/gradle/.gradle"
WORKDIR /home/gradle

RUN set -o errexit -o nounset \
	&& echo "Testing Gradle installation" \
	&& gradle --version

USER root
