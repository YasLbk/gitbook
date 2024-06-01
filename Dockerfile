FROM billryan/gitbook:base

# Add user jenkins as sudoer
RUN adduser jenkins --quiet --shell /bin/bash --disabled-password --gecos ' '
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

USER jenkins
WORKDIR /home/jenkins

## Set gitbook version

# install nvm
RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# nvm environment variables
ENV HOME "/home/jenkins"
ENV NVM_DIR "$HOME/.nvm"
ENV NODE_VERSION 9.5.0

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# install gitbook
RUN gitbook init

RUN rm *.md
# # copy docs
COPY --chown=jenkins:jenkins README.md /home/jenkins/
COPY --chown=jenkins:jenkins SUMMARY.md /home/jenkins/
COPY --chown=jenkins:jenkins .gitbook.yaml /home/jenkins/

RUN gitbook build
# RUN gitbook serve --port 4001

CMD ["bash"]
