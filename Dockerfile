FROM python:3.10.12-slim-bullseye

ENV PIPX_BIN_DIR=/usr/local/bin

WORKDIR /src

ENV SKIP_UPDATE=0

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN apt-get update && apt-get install -y \
  python3-dev \
  gcc \
  libc-dev \
  libffi-dev \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install virtualenv \
  && virtualenv /venv/sbom \
  && pip3 install pipx \
  && pipx install pip-audit \
  && pipx install pip-licenses \
  && pipx install pip-tools


ENTRYPOINT [ "sh", "-c", "entrypoint.sh" ]
