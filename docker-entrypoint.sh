#! /usr/bin/env sh

if [[ ${DEBUG} == 'TRUE' ]] || [[ ${DEBUG} == 'True' ]] || [[ ${DEBUG} == '1' ]]; then
    echo >&2 "Starting dev..."
    exec python -m debugpy --listen 0.0.0.0:5678 main.py
else
    echo >&2 "Starting prod..."
    exec python ./main.py
fi
