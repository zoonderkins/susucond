FROM debian:sid-slim AS susucond-blahdns

RUN wget https://secure.nic.cz/files/knot-resolver/knot-resolver-release.deb && dpkg -i knot-resolver-release.deb
RUN echo "deb http://cdn-fastly.deb.debian.org/debian sid main" > /etc/apt/sources.list
RUN apt-get update -qq && \
	apt-get -y -qqq install git build-essential luajit lua-sec lua-socket pkg-config bsdmainutils knot-resolver-module-http knot-resolver
  
FROM runtime
LABEL blahdns.vendor="blahdns"
LABEL maintainer="hi@blahdns.com"

# Export DNS over UDP & TCP, web interface
EXPOSE 53/UDP 53/TCP 8453/TCP

ENTRYPOINT ["/usr/sbin/kresd"]
CMD ["-c", "/etc/knot-resolver/kresd.conf"]
