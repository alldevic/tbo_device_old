FROM alpine:3.12.0 AS build
ARG DEBUG
ENV PYTHONUNBUFFERED 1
RUN mkdir -p /app 
RUN apk add --no-cache python3 py3-psutil py3-aiohttp
RUN if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi 
RUN apk add --no-cache --virtual .build-deps py3-pip
RUN pip install --disable-pip-version-check --no-cache-dir pipenv
WORKDIR /app
COPY Pipfile Pipfile.lock /app/

RUN if [[ "$DEBUG" == "TRUE" ]] || [[ "$DEBUG" == "True" ]] || [[ "$DEBUG" == "1" ]]; then \
    echo "Install with DEV packages"; \
    apk add --no-cache py3-pytest py3-flake8; \
    apk add --no-cache py3-rope py3-mypy py3-autopep8 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing; \
    pipenv install --system --deploy --ignore-pipfile --dev; \
    if [ ! -e /usr/bin/pip ]; then ln -sf pip3 /usr/bin/pip; fi; \
    else \
    echo "Install only PROD packages"; \
    pipenv install --system --deploy --ignore-pipfile; \
    pip uninstall filelock pipenv virtualenv virtualenv-clone -y; \
    fi && \
    apk --purge del .build-deps  && \
    rm -rf /root/.cache /root/.local \
    /etc/apk/ /usr/share/apk/ /lib/apk/ /sbin/apk \
    /media /usr/lib/terminfo /usr/share/terminfo \
    /usr/lib/python*/ensurepip \
    /usr/lib/python*/turtledemo /usr/lib/python*/turtle.py /usr/lib/python*/__pycache__/turtle.* \
    /var/cache/apk \
    /var/lib/apk && \
    if [[ "$DEBUG" != "TRUE" ]] && [[ "$DEBUG" != "True" ]] && [[ "$DEBUG" != "1" ]]; then \
    find /usr/lib/python*/* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf; \
    python3 -m compileall -b /usr/lib/python*; \
    find /usr/lib/python*/* -name "*.py"|xargs rm -rf; \
    find /usr/lib/python*/* -name '*.c' -delete; \
    find /usr/lib/python*/* -name '*.pxd' -delete; \
    find /usr/lib/python*/* -name '*.pyd' -delete; \
    find /usr/lib/python*/* -name '__pycache__' | xargs rm -r; \
    fi && \
    rm -rf /app/Pipfile* && \
    rm -rf /usr/lib/python*/site-packages/*.dist-info


FROM scratch AS deploy
ARG DEBUG
ENV PYTHONUNBUFFERED 1
ENV DEBUG ${DEBUG}

EXPOSE 5678
COPY --from=build / /
WORKDIR /app
