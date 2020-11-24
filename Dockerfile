FROM ucsb/pstat-115:v20201013.1
 
LABEL maintainer="Patrick Windmiller <windmiller@pstat.ucsb.edu>"

#USER root

#RUN R -e "install.packages(c('coda','mvtnorm','loo','dagitty','ggplot2'))"

#Run R -e "devtools::install_github('rmcelreath/rethinking')"

USER $NB_USER

