FROM jupyter/r-notebook:6d42503c684f
 
LABEL maintainer="Alexander Franks <amfranks@ucsb.edu>"

USER root
RUN git clone https://github.com/TheLocehiliosan/yadm.git /usr/local/share/yadm && \
    ln -s /usr/local/share/yadm/yadm /usr/local/bin/yadm
 
RUN pip install nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix
 
RUN pip install jupyter-server-proxy jupyter-rsession-proxy
 
## install R studio
RUN apt-get update && \
    curl --silent -L --fail https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-1.2.1578-amd64.deb > /tmp/rstudio.deb && \
    echo '81f72d5f986a776eee0f11e69a536fb7 /tmp/rstudio.deb' | md5sum -c - && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get remove -y r-*
ENV PATH=$PATH:/usr/lib/rstudio-server/bin
 
ENV R_HOME=/opt/conda/lib/R
 
## change littler defaults to conda R
ARG LITTLER=$R_HOME/library/littler
RUN echo "local({r <- getOption('repos'); r['CRAN'] <- 'https://cloud.r-project.org';  options(repos = r)})" > $R_HOME/etc/Rprofile.site

RUN R -e "install.packages(c('littler', 'docopt'))"
RUN sed -i 's/\/usr\/local\/lib\/R\/site-library/\/opt\/conda\/lib\/R\/library/g' $LITTLER/examples/*.r && \
        ln -s $LITTLER/bin/r $LITTLER/examples/*.r /usr/local/bin/ && \
        echo "$R_HOME/lib" | sudo tee -a /etc/ld.so.conf.d/littler.conf && \
        ldconfig
 
# ggplot2 extensions
RUN install2.r --error \
GGally \
ggridges \
RColorBrewer \
scales \
viridis
 
# Misc utilities
RUN install2.r --error \
beepr \
config \
doParallel \
DT \
foreach \
formattable \
glue \
here \
Hmisc \
httr
 
RUN install2.r --error \
jsonlite \
kableExtra \
logging \
MASS \
microbenchmark \
openxlsx \
rlang
 
RUN install2.r --error \
RPushbullet \
roxygen2 \
stringr \
styler \
testthat \
usethis  \
ggridges \
plotmo
 
 
# Caret and some ML packages
RUN install2.r --error \
# ML framework
caret \
car \
ensembleR \
# metrics
MLmetrics \
pROC \
ROCR \
# Models
Rtsne \
NbClust
 
RUN install2.r --error \
tree \
maptree \
arm \
e1071 \
elasticnet \
fitdistrplus \
gam \
gamlss \
glmnet \
lme4 \
ltm \
randomForest \
rpart \
# Data
ISLR

# added packages for Fall 2020
RUN install2.r --error \
patchwork

RUN conda install -y -c conda-forge r-cairo libv8
##    install2.r --error imager
 
# More Bayes stuff

RUN install2.r --error \
coda \
loo \
projpred \
MCMCpack \
hflights \
HDInterval \
tidytext \
dendextend \
LearnBayes \
imager


RUN installGithub.r \
     gbm-developers/gbm3 \
     bradleyboehmke/harrypotter
RUN R -e "install.packages(c('rstantools', 'shinystan'))"

RUN R -e "dotR <- file.path(Sys.getenv('HOME'), '.R'); if(!file.exists(dotR)){ dir.create(dotR) }; M <- file.path(dotR, 'Makevars'); if (!file.exists(M)){  file.create(M) }; cat('\nCXX14FLAGS=-O3 -Wno-unused-variable -Wno-unused-function', 'CXX14 = g++ -std=c++1y', file = M, sep = '\n', append = TRUE)"

# Editions made for eemb specific build 
RUN R -e "install.packages(c('coda','mvtnorm','loo','dagitty','ggplot2'))"
# End of eemb specific build commands

USER $NB_USER

# Editions made for eemb specific build
Run R -e "devtools::install_github('rmcelreath/rethinking')"
# End of eemb specific build commands

RUN R -e "devtools::install_github('ucbds-infra/ottr@0.0.2')"
