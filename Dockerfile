#syntax=docker/dockerfile:1
FROM ubuntu:latest

# COPY REQUIREMENTS TO CONTAINER
COPY apt_requirements.txt /apt_requirements.txt
COPY pip_requirements.txt /pip_requirements.txt
RUN ["apt-get", "update"]

# INSTALL APT-GET & PIP3 MODULES
RUN ["xargs", "-a", "/apt_requirements.txt", "apt-get", "install", "-y"]

# Python 3.7 소스 코드를 다운로드하고 컴파일하여 설치합니다.
RUN mkdir /usr/src/python \
    && cd /usr/src/python \
    && wget https://www.python.org/ftp/python/3.7.16/Python-3.7.16.tgz \
    && tar xzf Python-3.7.16.tgz \
    && cd Python-3.7.16 \
    && ./configure \
    && make \
    && make install

# Python 3.7을 최우선순위로 설정합니다.
RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.7 1

RUN ["pip3", "install", "-r", "/pip_requirements.txt"]

# CLONE GIT REPOSITORY
RUN ["git", "clone", "--branch", "v1.1.0/flask", "https://github.com/hanul-pipeline/hanul-site-pipeline", "/flask_compose"]

# ETC
# INSTALL NODE EXPORTER
RUN ["wget", "https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz"]
RUN ["tar", "xvf", "node_exporter-1.6.1.linux-amd64.tar.gz"]
RUN ["cp", "node_exporter-1.6.1.linux-amd64/node_exporter", "/usr/local/bin/"]

# AIRFLOW SETTINGS
RUN [ "airflow", "db", "init" ]
RUN [ "airflow", "users", "create", \
      "--username", "admin", \
      "--firstname", "Admin", \
      "--lastname", "User", \
      "--role", "Admin", \
      "--email", "admin@example.com", \
      "--password", "admin" ]

# ETC
# RUN NODE EXPORTER & APP
WORKDIR /flask_compose/src/flask
CMD ["bash", "-c", "python3 curl.py & node_exporter"]
# CMD ["bash", "-c", "python3 curl.py & node_exporter & airflow standalone"]
