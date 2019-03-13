FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    python3.6 python3-pip \
    libgconf2-4 libnss3 libxss1 libappindicator3-1\
    fonts-liberation libappindicator1 xdg-utils \
    software-properties-common \
    curl unzip wget \
    xvfb

# install geckodriver and firefox
RUN GECKODRIVER_VERSION=`curl https://github.com/mozilla/geckodriver/releases/latest | grep -Po 'v[0-9]+.[0-9]+.[0-9]+'` && \
    wget https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    tar -zxf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver

RUN add-apt-repository -y ppa:ubuntu-mozilla-daily/ppa
RUN apt-get update && apt-get install -y firefox


# install chromedriver and google-chrome
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/bin
RUN chmod +x /usr/bin/chromedriver

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome*.deb
RUN apt-get install -y -f


# install phantomjs
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar -jxf phantomjs-2.1.1-linux-x86_64.tar.bz2 && cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV GAUGE_TELEMETRY_ENABLED=false

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
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

RUN pip3 install --upgrade pip
RUN pip3 install selenium
RUN pip3 install pyvirtualdisplay
RUN pip3 install getgauge 
RUN rm -rf /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python

CMD gauge run -i false specs
