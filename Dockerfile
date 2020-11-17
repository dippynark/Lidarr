FROM debian:10.6

RUN apt-get update && apt-get install -y \
  gcc \
  python \
  unzip \
  curl \
  git \
  wget \
  gpg \
  make \
  nodejs \
  apt-transport-https

# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
RUN install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
RUN sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
RUN apt-get update && apt-get install -y code

# https://docs.microsoft.com/en-gb/dotnet/core/install/linux-debian
RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y dotnet-sdk-3.1

# https://classic.yarnpkg.com/en/docs/install
RUN cd /opt && \
  wget https://github.com/yarnpkg/yarn/releases/download/v1.22.10/yarn-v1.22.10.tar.gz && \
  tar zvxf yarn-v1.22.10.tar.gz
ENV PATH=/opt/yarn-v1.22.10/bin:$PATH

WORKDIR /workspace

RUN git clone https://github.com/Lidarr/Lidarr && \
  cd Lidarr && \
  git checkout develop && \
  yarn install
