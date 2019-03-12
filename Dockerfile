FROM python:3.6

ENV GAUGE_TELEMETRY_ENABLED=false

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install nodejs
RUN npm install -g npm@latest


WORKDIR /gauge

RUN npm install @getgauge/cli
RUN ln -s /gauge/node_modules/.bin/gauge /usr/bin/gauge

RUN gauge telemetry off
RUN gauge install python
RUN gauge install html-report

RUN echo '{\
  "Language": "python",\
  "Plugins": [\
    "html-report"\
  ]\
}'\
  >> /gauge/manifest.json

COPY env /gauge/env

RUN pip install --upgrade pip
RUN pip install getgauge 
RUN pip show getgauge

CMD gauge run specs
