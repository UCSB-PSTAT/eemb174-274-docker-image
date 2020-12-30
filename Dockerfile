FROM ucsb/eemb174-274:v20201124.4

LABEL maintainer="Alexander Franks <amfranks@ucsb.edu>"

USER root

#-- Requirements
RUN apt-get update && apt-get install -y g++ git subversion automake \
libtool zlib1g-dev libicu-dev libboost-all-dev libbz2-dev liblzma-dev \
python-dev graphviz imagemagick make cmake libgoogle-perftools-dev autoconf gawk \
doxygen libpixman-1-dev pkg-config libpng-dev && rm -rf /var/lib/apt/lists/*

#-- Install cairo
WORKDIR /tmp
ADD cairo-1.16.0.tar.xz /tmp
WORKDIR /tmp/cairo-1.16.0
#RUN tar xvzf rcairo-1.16.6.tar.gz && Makefile && make
RUN ./configure --prefix=/tmp/cairob && make && make install
RUN cp -r /tmp/cairob/lib/* /usr/lib/x86_64-linux-gnu/

RUN R -e "install.packages(c('Cairo'))"

RUN chmod -R 777 /opt/conda/lib/R/library

WORKDIR /home/jovyan

USER $NB_USER
