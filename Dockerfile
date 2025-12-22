FROM lscr.io/linuxserver/webtop:debian-xfce 
EXPOSE 5901

RUN curl -fsS https://dl.brave.com/install.sh | sh

RUN apt-get install wget gpg
RUN wget -qO- "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | gpg --dearmor > windsurf-stable.gpg
RUN install -D -o root -g root -m 644 windsurf-stable.gpg /etc/apt/keyrings/windsurf-stable.gpg
RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/windsurf-stable.gpg] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | tee /etc/apt/sources.list.d/windsurf.list > /dev/null
RUN rm -f windsurf-stable.gpg

RUN apt-get update && sudo apt install apt-transport-https &&apt-get install -y windsurf

RUN apt-get install -y tigervnc-standalone-server

RUN apt-get install -y net-tools inetutils-tools inetutils-ping nano unzip libfuse2

RUN mv /usr/bin/brave-browser /usr/bin/og-brave-browser \
    && mv /usr/bin/brave-browser-stable /usr/bin/og-brave-browser-stable \
    && mv /usr/bin/chromium /usr/bin/og-chromium \
    && mv /usr/bin/windsurf /usr/bin/og-windsurf

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

RUN curl -L --output timebomb.tar.gz https://github.com/beamvex/time-bomb/releases/download/v1.0.1/time-bomb-v1.0.1-linux-x86_64.tar.gz \
    && tar -xvf timebomb.tar.gz \
    && mv time-bomb-1.0.0 /usr/lib/timebomb \
    && rm timebomb.tar.gz

COPY root/ /

RUN chmod +x /usr/bin/brave-browser-stable \
    && chmod +x /usr/bin/brave-browser \
    && chmod +x /usr/bin/chromium \
    && chmod +x /usr/bin/windsurf \
    && chmod +x /usr/bin/timebomb

