FROM ubuntu:22.04

Label maintainer="rdemko2332@gmail.com"

WORKDIR /usr/bin/

RUN apt-get -qq update --fix-missing \
  && apt-get install -y wget perl libgomp1 git ant build-essential unzip default-jre python3 cpanminus bioperl libaio1 emacs libjson-perl libmodule-install-rdf-perl libxml-parser-perl openjdk-8-jdk libdate-manip-perl libtext-csv-perl libstatistics-descriptive-perl libtree-dagnode-perl libxml-simple-perl && apt-get clean \
  && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /gusApp
WORKDIR /gusApp/gus_home
WORKDIR /gusApp/project_home

ENV GUS_HOME=/gusApp/gus_home
ENV PROJECT_HOME=/gusApp/project_home
ENV PATH=$PROJECT_HOME/install/bin:$PATH
ENV PATH=$GUS_HOME/bin:$PATH

RUN export INSTALL_GIT_COMMIT_SHA=05197ebc4eb2046cc16e632b0b5852f21727a209 \
    && git clone https://github.com/VEuPathDB/install.git \
    && cd install \
    && git checkout $INSTALL_GIT_COMMIT_SHA

RUN mkdir -p $GUS_HOME/config && cp $PROJECT_HOME/install/gus.config.sample $GUS_HOME/config/gus.config

RUN export CBIL_GIT_COMMIT_SHA=41e17a8c7c61a6ca55fd28bd0f4883c74dcb625c \
    && git clone https://github.com/VEuPathDB/CBIL.git \
    && cd CBIL \
    && git checkout $CBIL_GIT_COMMIT_SHA \
    && bld CBIL

RUN export GUS_GIT_COMMIT_SHA=b11d5a179c5d48af134929c94b68bb908ab53bd6 \
    && git clone https://github.com/VEuPathDB/GusAppFramework.git \
    && mv GusAppFramework GUS \
    && cd GUS \
    && git checkout $GUS_GIT_COMMIT_SHA \
    && bld GUS/PluginMgr \
    && bld GUS/Supported

RUN export APICOMMONDATA_GIT_COMMIT_SHA=cf3e3daf2337a88462060439bd1fcf3a4b714c34 \
    && git clone https://github.com/VEuPathDB/ApiCommonData.git \
    && cd ApiCommonData \
    && git checkout $APICOMMONDATA_GIT_COMMIT_SHA \
    && mkdir -p $GUS_HOME/lib/perl/ApiCommonData/Load/Plugin \ 
    && cp $PROJECT_HOME/ApiCommonData/Load/plugin/perl/*.pm $GUS_HOME/lib/perl/ApiCommonData/Load/Plugin/ \
    && cp $PROJECT_HOME/ApiCommonData/Load/lib/perl/*.pm $GUS_HOME/lib/perl/ApiCommonData/Load/

RUN mkdir /gusApp/gus_home/lib/perl/GUS/Community \
    && cp /gusApp/project_home/GUS/Community/lib/perl/GeneModelLocations.pm /gusApp/gus_home/lib/perl/GUS/Community/
ENV PERL5LIB=/gusApp/gus_home/lib/perl

WORKDIR /usr/bin/

# Setting up ncbi blast tools
RUN wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.13.0+-x64-linux.tar.gz \
  && tar -zxvf ncbi-blast-2.13.0+-x64-linux.tar.gz \
  && rm -rf ncbi-blast-2.13.0+-x64-linux.tar.gz

ADD /bin/*.pl /usr/bin/

# Making all blast tools executable
RUN chmod +x * \
  && cd ncbi-blast-2.13.0+/bin  \
  &&  chmod +x *

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/ncbi-blast-2.13.0+/bin:/usr/bin/ncbi-blast-2.13.0+

WORKDIR /work