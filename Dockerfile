FROM python:3.12.3-bookworm AS builder

RUN pip install poetry==1.8.2
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app
COPY pyproject.toml poetry.lock ./

RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --without dev --no-root

FROM builder AS dev

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

RUN --mount=type=cache,target=$POETRY_CACHE_DIR  poetry install

COPY src /app/src
WORKDIR /app

CMD uvicorn src.main:app --reload --host 0.0.0.0 --port ${SERVER_PORT}

FROM python:3.12.3-slim-bookworm AS production

WORKDIR /app

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

COPY src /app/src
WORKDIR /app

CMD uvicorn src.main:app --reload --host 0.0.0.0 --port ${SERVER_PORT}
