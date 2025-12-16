FROM lscr.io/linuxserver/webtop:debian-xfce 
EXPOSE 5901

RUN curl -fsS https://dl.brave.com/install.sh | sh

RUN apt-get install wget gpg
RUN wget -qO- "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | gpg --dearmor > windsurf-stable.gpg
RUN install -D -o root -g root -m 644 windsurf-stable.gpg /etc/apt/keyrings/windsurf-stable.gpg
RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/windsurf-stable.gpg] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | tee /etc/apt/sources.list.d/windsurf.list > /dev/null
RUN rm -f windsurf-stable.gpg

RUN apt-get update && sudo apt install apt-transport-https &&apt-get install -y windsurf

COPY root/etc/s6-overlay/s6-rc.d/ /etc/s6-overlay/s6-rc.d/


