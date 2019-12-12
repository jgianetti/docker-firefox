#
# https://github.com/jgianetti/docker-firefox/
#

FROM debian:buster-slim

ARG UID
ENV UID=${UID:-1000} \
    PULSE_COOKIE=/tmp/pulse_cookie

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
       firefox-esr \
       pulseaudio-utils \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash --uid $UID developer

# firefox strict mode
# using every other method (eg. user.js): browser.contentblocking.category gets reseted
COPY ./autoconfig.js /usr/lib/firefox-esr/defaults/pref/autoconfig.js
COPY ./autoconfig.cfg /usr/lib/firefox-esr/

COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER developer

ENTRYPOINT ["entrypoint.sh"]
CMD ["firefox"]
