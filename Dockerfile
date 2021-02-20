FROM python:3.8-alpine3.12

RUN python3 -m pip install --upgrade pip

RUN apk add --no-cache --virtual \
        .build_deps \
        libressl-dev \
        musl-dev \
        libffi-dev \
        gcc

RUN pip install poetry
RUN poetry config virtualenvs.create false

WORKDIR /app

COPY poetry.lock pyproject.toml /app/
COPY libs/ /app/libs/
RUN poetry install

COPY source/ /app/source

CMD streamlit run source/index.py