FROM ucsb/r-base:v20210120.1

LABEL maintainer="Patrick Windmiller <windmiller@pstat.ucsb.edu>"

USER root

RUN apt update && apt install -y \
    nano \
    libpixman-1-dev \
    libcairo2-dev \
    libxt-dev && \
    apt-get clean 

#-- RSTAN
#-- install rstan reqs
RUN R -e "install.packages(c('inline','gridExtra','loo'))"
#-- install rstan
RUN R -e "dotR <- file.path(Sys.getenv('HOME'), '.R'); if(!file.exists(dotR)){ dir.create(dotR) }; Makevars <- file.path(dotR, 'Makevars'); if (!file.exists(Makevars)){  file.create(Makevars) }; cat('\nCXX14FLAGS=-O3 -fPIC -Wno-unused-variable -Wno-unused-function', 'CXX14 = g++ -std=c++1y -fPIC', file = Makevars, sep = '\n', append = TRUE)"
RUN R -e "install.packages(c('ggplot2','StanHeaders'))"
RUN R -e "packageurl <- 'http://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.19.3.tar.gz'; install.packages(packageurl, repos = NULL, type = 'source')"

#-- ggplot2 extensions
RUN R -e "install.packages(c('GGally','ggridges','viridis'))"

#-- Misc utilities
RUN R -e "install.packages(c('beepr','config','tinytex','rmarkdown','formattable','here','Hmisc'))"

RUN R -e "install.packages(c('kableExtra','logging','microbenchmark','openxlsx'))"

RUN R -e "install.packages(c('RPushbullet','styler','ggridges','plotmo'))"

RUN R -e "install.packages(c('nloptr'))"

RUN R --vanilla -e "install.packages('minqa',repos='https://cloud.r-project.org', dependencies=TRUE)"

#-- Caret and some ML packages
#-- ML framework, metrics and Models
RUN rm -rf /opt/microsoft/ropen/4.0.2/lib64/R/library/codetools
RUN R -e "install.packages(c('codetools'))"
RUN R --vanilla -e "install.packages('caret',repos='https://cloud.r-project.org')"
RUN R -e "install.packages(c('car','ensembleR','MLmetrics','pROC','ROCR','Rtsne','NbClust'))"

RUN R -e "install.packages(c('tree','maptree','arm','e1071','elasticnet','fitdistrplus','gam','gamlss','glmnet','lme4','ltm','randomForest','rpart','ISLR'))"

#-- More Bayes stuff

RUN R -e "install.packages(c('projpred','MCMCpack','hflights','HDInterval','tidytext','dendextend','LearnBayes'))"

RUN R -e "install.packages(c('rstantools', 'shinystan'))"

RUN R -e "install.packages(c('dagitty','tidyverse'))"

RUN R -e "install.packages('posterior', repos = 'https://cran.r-project.org/')"

RUN R -e "install.packages('cmdstanr', repos = 'https://mc-stan.org/r-packages/')"

RUN R -e "devtools::install_github('rmcelreath/rethinking', upgrade = c('never'))"

RUN R -e "install.packages(c('Cairo'))"

USER $NB_USER
