FROM openjdk:8-jdk-alpine

MAINTAINER Yoan-Alexander Grigorov <joan.grigorov@gmail.com>

ENV GLAGOL_DSL_PORT=51151
ENV MEMORY_LIMIT=512

RUN mkdir /usr/local/src

ADD glagol-server /usr/bin/glagol-server
ADD glagol-dsl.jar /usr/local/src/glagol-dsl-server.jar

RUN chmod +x /usr/bin/glagol-server

EXPOSE ${GLAGOL_DSL_PORT}/tcp

ENTRYPOINT ["glagol-server"]
CMD ["daemon", "${GLAGOL_DSL_PORT}"]
