FROM prom/prometheus:latest
COPY ./monitoring/prometheus /etc/grafana/provisioning/datasources
EXPOSE 9090
CMD [ "--config.file=/etc/prometheus/prometheus.yml"]