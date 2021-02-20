FROM python:3.8-alpine3.12

# Install dependencies for python packages
RUN apk add --no-cache --virtual \
    .build_deps \
    libressl-dev \
    musl-dev \
    libffi-dev \
    openssl-dev \
    libzmq \
    zeromq-dev \
    gcc

# Upgrade pip if necessary
RUN python3 -m pip install --upgrade pip

# Workaround for criptography error
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN pip install poetry
RUN poetry config virtualenvs.create false

WORKDIR /app

COPY poetry.lock pyproject.toml /app/
COPY libs/ /app/libs/
RUN poetry install

COPY source/ /app/source

CMD streamlit run source/index.py