FROM ubuntu:22.04

Label maintainer="rdemko2332@gmail.com"

WORKDIR /usr/bin/

RUN apt-get -qq update --fix-missing \
  && apt-get install -y wget perl libgomp1 git ant build-essential unzip default-jre python3 cpanminus bioperl libaio1 emacs libjson-perl libmodule-install-rdf-perl libxml-parser-perl openjdk-8-jdk libdate-manip-perl libtext-csv-perl libstatistics-descriptive-perl libtree-dagnode-perl libxml-simple-perl && apt-get clean \
  && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /usr/bin/

# Setting up ncbi blast tools
RUN wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.13.0/ncbi-blast-2.13.0+-x64-linux.tar.gz \
  && tar -zxvf ncbi-blast-2.13.0+-x64-linux.tar.gz \
  && rm -rf ncbi-blast-2.13.0+-x64-linux.tar.gz

ADD /bin/*.pl /usr/bin/

# Making all blast tools executable
RUN chmod +x * \
  && cd ncbi-blast-2.13.0+/bin  \
  &&  chmod +x *

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/ncbi-blast-2.13.0+/bin:/usr/bin/ncbi-blast-2.13.0+

WORKDIR /work