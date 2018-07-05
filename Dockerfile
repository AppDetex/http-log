FROM debian:stable-slim

EXPOSE 8080

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y curl gnupg2 && \
	curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
	apt-get install --no-install-suggests --no-install-recommends -y \
		nodejs && \
	addgroup -gid 5000 -group app && \
	adduser --home /opt/app --shell /bin/false --gid 5000 app && \	
	apt-get -y clean && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*

COPY code /opt/app

WORKDIR /opt/app
USER app
CMD [ "node", "main.js" ]
