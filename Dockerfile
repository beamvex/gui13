FROM lscr.io/linuxserver/webtop:debian-xfce 
EXPOSE 5901

RUN curl -fsS https://dl.brave.com/install.sh | sh

COPY root/etc/s6-overlay/s6-rc.d/ /etc/s6-overlay/s6-rc.d/


