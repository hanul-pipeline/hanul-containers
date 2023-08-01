# syntax=docker/dockerfile:1
FROM ubuntu:latest

RUN ["apt-get", "update"]
RUN ["mkdir","flask_compose"]
RUN ["apt-get","install", "-y","cron"]
RUN ["apt-get","install","-y","vim"]
RUN ["apt-get", "install", "-y", "sqlite3"]

RUN ["apt-get","install","-y","git"]
#RUN ["git","clone","https://github.com/hanul-pipeline/hanul-site-pipeline","/flask_compose"]
RUN ["git", "clone", "--branch", "v1.1.0/flask", "https://github.com/hanul-pipeline/hanul-site-pipeline", "/flask_compose"]

RUN ["apt-get", "install", "-y", "python3-pip"]
RUN ["pip", "install", "mysql-connector-python"] 

RUN ["apt-get", "install", "-y", "wget"]
RUN ["wget", "https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz"]
RUN ["tar", "xvf", "node_exporter-1.6.1.linux-amd64.tar.gz"]
RUN ["cp", "node_exporter-1.6.1.linux-amd64/node_exporter", "/usr/local/bin/"]


WORKDIR /flask-compose/src/flask

CMD ["bash", "-c", "python3 curl.py & node_exporter"]
