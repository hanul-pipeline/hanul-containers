# syntax=docker/dockerfile:1
FROM ubuntu:latest
RUN ["apt", "update"]
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
Run ["mkdir","-y","flask_compose"]
RUN ["apt","install", "-y","cron"]
RUN ["apt","install","-y","vim"]
RUN ["apt","install","-y","pip"]
RUN ["apt","install","-y","git"]
RUN ["git","clone","https://github.com/hanul-pipeline/hanul-site-pipeline","/flask_compose"]
COPY ["requirements.txt", "requirements.txt"]
RUN ["pip", "install","-r","requirements.txt"]
EXPOSE 5000
COPY . .
CMD ["flask", "run"]
