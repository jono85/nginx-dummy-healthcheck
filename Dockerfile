FROM nginx:alpine

COPY app /app
RUN chmod +x /app/*.sh 

ENV DUMMY_SERVER_PORT=0
ENV DUMMY_SERVER_SSL_PORT=0

ENTRYPOINT /app/entrypoint.sh
