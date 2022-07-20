FROM ubuntu:kinetic

USER root 

ENV TZ=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y bash firehol-tools

ARG USERID
ENV UID=$USERID

ARG GROUPID
ENV GID=$GROUPID

RUN addgroup --gid $GID analyst
RUN useradd analyst -u$UID -g$GID -d/home/analyst -s/bin/bash

RUN mkdir /home/analyst
WORKDIR /home/analyst
COPY . .
RUN chmod +x runner.sh
RUN chown -R $GID:$UID /home/analyst
USER analyst

#CMD /bin/bash
CMD "/home/analyst/runner.sh"

