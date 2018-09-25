FROM telephoneorg/debian:stretch

LABEL maintainer="Alexander Mustafin <mustafin.aleksandr@gmail.com>"

#Build stage variables
ARG BRANCH="master"
ARG REPO="https://gitlab.com/bmitelecom/yeti/yeti-management.git"

ENV APP yeti-management
ENV USER $APP
ENV HOME /home/$APP

ENV MANAGER_ADDRESS 0.0.0.0
ENV MANAGER_PORT 4444
ENV MANAGER_LOG_LEVEL 2

COPY build.sh /tmp/build.sh
RUN /tmp/build.sh

#Set working directory
WORKDIR $HOME

# Expose a volume with configuration
VOLUME ["$HOME"]

SHELL ["/bin/bash", "-lc"]

HEALTHCHECK --interval=15s --timeout=5s \
    CMD netcat $MANAGER_ADDRESS $MANAGER_PORT || exit 1

COPY entrypoint /

# The default command that gets ran will be to start the yeti-management daemon.
ENTRYPOINT ["/dumb-init", "--"]
CMD ["/entrypoint"]
