FROM selenium/standalone-chrome:3.141.59
USER root

# Install some additional Japanese fonts
ENV DEBCONF_NOWARNINGS yes
RUN apt-get update -qq \
  && apt-get install -y fonts-noto fonts-ipafont \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && fc-cache -fv
