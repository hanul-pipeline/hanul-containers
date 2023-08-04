#syntax=docker/dockerfile:1
FROM ubuntu:latest

# COPY REQUIREMENTS TO CONTAINER
COPY apt_requirements.txt /apt_requirements.txt
COPY pip_requirements.txt /pip_requirements.txt
RUN ["apt-get", "update"]

# INSTALL APT-GET & PIP3 MODULES
RUN ["xargs", "-a", "/apt_requirements.txt", "apt-get", "install", "-y"]
RUN ["pip3", "install", "-r", "/pip_requirements.txt"]

# CLONE GIT REPOSITORY
RUN ["git", "clone", "--branch", "v1.1.0/flask", "https://github.com/hanul-pipeline/hanul-site-pipeline", "/flask_compose"]

# ETC
# INSTALL NODE EXPORTER
RUN ["wget", "https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz"]
RUN ["tar", "xvf", "node_exporter-1.6.1.linux-amd64.tar.gz"]
RUN ["cp", "node_exporter-1.6.1.linux-amd64/node_exporter", "/usr/local/bin/"]

# ETC
# RUN NODE EXPORTER & APP
WORKDIR /flask_compose/src/flask
CMD ["bash", "-c", "python3 curl.py & node_exporter"]
