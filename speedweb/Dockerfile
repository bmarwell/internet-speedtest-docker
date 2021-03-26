FROM grafana/grafana
MAINTAINER Pedro César de Azevedo <pedrocesar.ti@gmail.com>
MAINTAINER Benjamin Marwell <bmarwell@apache.org>

ADD conf/grafana.db /var/lib/grafana/grafana.db
ADD conf/home.json /usr/share/grafana/public/dashboards/home.json

ENV GF_SERVER_ROOT_URL http://localhost
ENV GF_SECURITY_ADMIN_USER admin
ENV GF_SECURITY_ADMIN_PASSWORD admin
ENV GF_AUTH_ANONYMOUS_ENABLED true

USER root
RUN chown -R root:root /etc/grafana && \
  chmod -R a+r /etc/grafana && \
  chown -R grafana:root /var/lib/grafana

USER grafana
ENTRYPOINT ["/run.sh"]
