FROM microsoft/dotnet:2.0-sdk

# make Apt non-interactive
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci \
  && echo 'APT::Get::force-Yes "true";' >> /etc/apt/apt.conf.d/90circleci \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y \
    git \
    openssh-client \
    ca-certificates \
    tar gzip unzip zip bzip2 \
    make xsltproc

CMD ["/bin/sh"]

ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
