FROM ubuntu:16.04


RUN apt-get update
RUN apt-get install -y build-essential wget git
RUN apt-get install -y zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get install -y aspell aspell-en graphviz graphviz-dev
RUN apt-get install -y perl cpanminus
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY cpanfile /root/app/cpanfile
RUN cpanm GraphViz2 ExtUtils::MakeMaker~6.68
RUN cd /root/app; cpanm --installdeps .

COPY . /root/app
WORKDIR /root/app

RUN perl Build.PL && ./Build && ./Build install
ENTRYPOINT ["perl", "main.p"]
