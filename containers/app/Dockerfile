FROM ruby:2.6.3

# Use UTF-8
ENV LANG C.UTF-8

# Install applications
ENV DEBCONF_NOWARNINGS yes
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    vim \
    nodejs \
    postgresql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Entrykit
ENV ENTRYKIT_VERSION 0.4.0
RUN wget -q https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

# Configure Bundler
RUN bundle config build.nokogiri --use-system-libraries

# Rails Application
RUN mkdir /opt/railsapp
WORKDIR /opt/railsapp

ENTRYPOINT [ \
  "prehook", "ruby -v", "--", \
  "prehook", "bundle install --without production -j4 --quiet", "--", \
  "prehook", "rails -v", "--", \
  "prehook", "echo --------", "--" ]
