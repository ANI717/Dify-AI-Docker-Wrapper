# base image
FROM python:3.11-slim-bullseye AS base

WORKDIR /app/api

# Install uv
ENV UV_VERSION=0.8.9

RUN pip install --no-cache-dir uv==${UV_VERSION}


FROM base AS packages

# if you located in China, you can use aliyun mirror to speed up
# RUN sed -i 's@deb.debian.org@mirrors.aliyun.com@g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc g++ libc-dev libffi-dev libgmp-dev libmpfr-dev libmpc-dev

# Install Python dependencies
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev

# production stage
FROM base AS production

ENV FLASK_APP=app.py
ENV EDITION=SELF_HOSTED
ENV DEPLOY_ENV=PRODUCTION
ENV CONSOLE_API_URL=http://127.0.0.1:5001
ENV CONSOLE_WEB_URL=http://127.0.0.1:3000
ENV SERVICE_API_URL=http://127.0.0.1:5001
ENV APP_WEB_URL=http://127.0.0.1:3000

# Force all temp/caches/logs to /temp
RUN mkdir -p /temp && chmod 1777 /temp
ENV TMPDIR=/temp \
    XDG_CACHE_HOME=/temp/.cache \
    PIP_CACHE_DIR=/temp/pip \
    UV_CACHE_DIR=/temp/uv \
    NLTK_DATA=/temp/nltk_data \
    HUGGINGFACE_HUB_CACHE=/temp/hf \
    HF_HOME=/temp/hf \
    TRANSFORMERS_CACHE=/temp/transformers \
    MPLCONFIGDIR=/temp/mpl \
    PYTHONPYCACHEPREFIX=/temp/__pycache__ \
    TIKTOKEN_CACHE_DIR=/temp/tiktoken \
    SQLALCHEMY_DATABASE_URI=sqlite:////temp/app.db \
    FLASK_INSTANCE_PATH=/temp/flask-instance \
    UVICORN_WORKERS=1 \
    PYTHONDONTWRITEBYTECODE=1

EXPOSE 5001

# set timezone
ENV TZ=UTC

# Set UTF-8 locale
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV PYTHONIOENCODING=utf-8

WORKDIR /app/api

RUN \
    apt-get update \
    # Install dependencies
    && apt-get install -y --no-install-recommends \
        # basic environment
        curl nodejs libgmp-dev libmpfr-dev libmpc-dev \
        # For Security
        expat libldap-2.4-2 libldap2-dev perl libsqlite3-0 zlib1g \
        # install fonts to support the use of tools like pypdfium2
        fonts-noto-cjk \
        # install a package to improve the accuracy of guessing mime type and file extension
        media-types \
        # install libmagic to support the use of python-magic guess MIMETYPE
        libmagic1 \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Copy Python environment and packages
ENV VIRTUAL_ENV=/app/api/.venv
COPY --from=packages ${VIRTUAL_ENV} ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

# Download nltk data
RUN python -c "import nltk; nltk.download('punkt'); nltk.download('averaged_perceptron_tagger')"

ENV TIKTOKEN_CACHE_DIR=/app/api/.tiktoken_cache

RUN python -c "import tiktoken; tiktoken.encoding_for_model('gpt2')"

# Copy source code
COPY . /app/api/

# Create non-root user
RUN groupadd --gid 1001 appuser \
    && useradd --uid 1001 --gid appuser --shell /bin/bash --create-home appuser

# Copy entrypoint
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Change ownership of app directory to appuser
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

ARG COMMIT_SHA
ENV COMMIT_SHA=${COMMIT_SHA}

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
