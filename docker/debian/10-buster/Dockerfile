
FROM debian:buster

RUN echo "test" > /etc/hostname

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y aptitude

RUN aptitude install -y git wget
RUN aptitude install -y r-base-core
RUN aptitude install -y r-cran-xml2 r-cran-xslt

RUN chmod -R a+wx /usr/local

RUN adduser dev

USER dev

CMD cat
