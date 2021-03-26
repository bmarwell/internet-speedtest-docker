FROM python:3-slim
MAINTAINER Pedro César de Azevedo <pedrocesar.ti@gmail.com>
MAINTAINER Benjamin Marwell <bmarwell@apache.org>

RUN apt-get update && apt-get install -y \
      curl \
      jq  \
      && rm -rf /var/lib/apt/lists/*
# not using speedtest.net because of possible privacy issues (they take data)
RUN mkdir -p /app/speedtest/ \
      && curl --silent --fail --location --max-time 5 --retry 1 https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -o /app/speedtest/speedtest-cli \
      && chmod +x /app/speedtest/speedtest-cli

ADD scripts/ /app/speedtest/

CMD bash -c /app/speedtest/init_test_connection.sh
