# syntax=docker/dockerfile:1
FROM ubuntu:latest

RUN ["apt", "update"]
RUN ["mkdir","flask_compose"]
RUN ["apt","install", "-y","cron"]
RUN ["apt","install","-y","vim"]
RUN ["apt", "install", "-y", "sqlite3"]

RUN ["apt","install","-y","git"]
RUN ["git","clone","https://github.com/hanul-pipeline/hanul-site-pipeline","/flask_compose"]

RUN ["apt", "install", "-y", "python3-pip"]
RUN ["pip", "install", "mysql-connector-python"] 

RUN ["apt", "install", "-y", "wget"]
RUN ["wget", "https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz"]
RUN ["tar", "xvf", "node_exporter-1.2.2.linux-amd64.tar.gz"]
RUN ["cp", "node_exporter-1.2.2.linux-amd64/node_exporter", "/usr/local/bin/"]

WORKDIR /flask-compose/src/flask

CMD ["bash", "-c", "python3 curl.py & node_exporter"]
